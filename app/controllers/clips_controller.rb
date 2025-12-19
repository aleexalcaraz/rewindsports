class ClipsController < ApplicationController
    allow_unauthenticated_access

    CLIPS_ROOT_PATH = ENV['CLIPS_ROOT_PATH'] || "/Users/alejandroalcaraz/Documents/Indie/padel-bot"

    def index
        puts "Searching in path: #{CLIPS_ROOT_PATH}"
        @video_files = []
        if params[:club_id].present? && params[:court_id].present?
            club = Club.find(params[:club_id])
            court = Court.find(params[:court_id])
            
            hour = params[:hour]
            date = params[:date]

            relative_path = File.join(club.name, court.name, 'clips')
            search_path = File.join(CLIPS_ROOT_PATH, relative_path)

            puts "Searching in path: #{search_path}"
            
            if Dir.exist?(search_path)
                video_files = Dir.entries(search_path).select do |f|
                    f.match?(/\.(mp4|webm|mov|ogg)$/i)
                end

                if date.present? && hour.present?
                    start_hour = hour.to_i
                    end_hour = start_hour + 2
                    
                    video_files.select! do |f|
                        # Filename format: 2025-03-29_21-25-24_clip.mp4
                        match = f.match(/^(\d{4}-\d{2}-\d{2})_(\d{2})/)
                        next false unless match

                        file_date_str = match[1]
                        file_hour = match[2].to_i

                        file_date_str == date && (start_hour..end_hour).cover?(file_hour)
                    end
                end

                @video_files = video_files.map do |f|
                    File.join(relative_path, f)
                end
            else
                flash.now[:alert] = "Directory not found for the selected club and court."
            end
        end
    end

    # def serve
    #     filename = params[:filename]
        
    #     disposition = params[:disposition] == 'download' ? 'attachment' : 'inline'

    #     full_path = File.join(CLIPS_ROOT_PATH, filename)   

    #     unless full_path.start_with?(CLIPS_ROOT_PATH) && File.exist?(full_path)
    #     head :not_found and return
    #     end

    #     send_file(
    #         full_path,
    #         filename: filename,
    #         type: 'video/mp4',
    #         disposition: disposition
    #     )
    # end

    def serve
        filename = params[:filename]
        disposition = params[:disposition] == 'download' ? 'attachment' : 'inline'
        full_path = File.join(CLIPS_ROOT_PATH, filename)

        unless full_path.start_with?(CLIPS_ROOT_PATH) && File.exist?(full_path)
            head :not_found and return
        end

        file_size = File.size(full_path)

        if request.headers['Range']
            # iOS sends a header like "bytes=0-1"
            range = request.headers['Range'].match(/bytes=(\d+)-(\d*)/)
            start_byte = range[1].to_i
            end_byte = range[2].to_i.zero? ? file_size - 1 : range[2].to_i
            length = end_byte - start_byte + 1

            # Important headers for iOS streaming
            response.headers['Content-Range'] = "bytes #{start_byte}-#{end_byte}/#{file_size}"
            response.headers['Accept-Ranges'] = 'bytes'
            
            # We send only the requested chunk of data
            send_data IO.binread(full_path, length, start_byte), 
                    type: 'video/mp4', 
                    disposition: disposition, 
                    status: :partial_content # This sends Status 206
        else
            # Standard request for the whole file
            response.headers['Accept-Ranges'] = 'bytes'
            send_file full_path, 
                    type: 'video/mp4', 
                    disposition: disposition
        end
    end
end
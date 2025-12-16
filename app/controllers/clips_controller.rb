class ClipsController < ApplicationController
    allow_unauthenticated_access

    CLIPS_ROOT_PATH = ENV['CLIPS_ROOT_PATH'] || "/Users/alejandroalcaraz/Documents/Indie/padel-bot/SuperPadel/Cancha1/clips"

    def index
        @video_files = Dir.entries(CLIPS_ROOT_PATH).select do |f|
            f.match?(/\.(mp4|webm|mov|ogg)$/i)
        end
    end

    def serve
        filename = params[:filename]
        
        disposition = params[:disposition] == 'download' ? 'attachment' : 'inline'

        full_path = File.join(CLIPS_ROOT_PATH, filename)   

        unless full_path.start_with?(CLIPS_ROOT_PATH) && File.exist?(full_path)
        head :not_found and return
        end

        send_file(
            full_path,
            filename: filename,
            type: 'video/mp4',
            disposition: disposition
        )
    end
end
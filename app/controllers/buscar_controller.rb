class BuscarController < ApplicationController
    allow_unauthenticated_access

    def index
        @clubs = Club.all
        @courts = []
    end

    def courts
        @courts = Court.where(club_id: params[:club_id])
        render json: @courts.map { |court| { id: court.id, name: court.name } }
    end
end

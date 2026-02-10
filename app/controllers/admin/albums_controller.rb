module Admin
  class AlbumsController < ApplicationController
    before_action :set_album, only: %i[ edit update ]

    def index
      @pagy, @albums = pagy(Album.order(created_at: :desc), limit: 12)
    end

    def edit
    end

    def update
    end

    private
      def set_album
        @album = Album.find(params[:id])
      end
  end
end

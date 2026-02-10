module Admin
  class AlbumsController < ApplicationController
    before_action :set_album, only: %i[ edit update ]
    before_action :set_photos, only: %i[ edit update ]

    def index
      @pagy, @albums = pagy(Album.includes(:photos).order(created_at: :desc), limit: 12)
    end

    def edit
    end

    def update
      if @album.update(album_params)
        redirect_to admin_albums_path, notice: "Album was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_album
        @album = Album.find(params[:id])
      end

      def album_params
        params.require(:album).permit(:title, :description, :album_sharing, photo_ids: [])
      end

      def set_photos
        user_id = @album.user_id
        @photos = Photo.where(user_id: user_id)
      end
  end
end

module Admin
  class PhotosController < ApplicationController
    before_action :set_photo, only: %i[ edit update ]

    def index
      @pagy, @photos = pagy(Photo.order(created_at: :desc), limit: 12)
    end

    def edit
    end

    def update
      if @photo.update(photo_params)
        redirect_to admin_photos_path, notice: "Photo was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:title, :description, :image, :photo_sharing, :image_cache)
    end
  end
end

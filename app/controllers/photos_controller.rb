class PhotosController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    @pagy, @photos = pagy(:countless, Photo.public_photos.includes(:user).order(created_at: :desc), limit: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = current_user.photos.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @photo = current_user.photos.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to profile_path, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        flash.now[:alert] = @photo.errors.full_messages.to_sentence.presence || "Create failed. Please check the form."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to profile_path, notice: "Photo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @photo }
      else
        flash.now[:alert] = @photo.errors.full_messages.to_sentence.presence || "Update failed. Please check the form."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy!

    respond_to do |format|
      format.html { redirect_to profile_path, notice: "Photo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = if user_signed_in?
        begin
          current_user.photos.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          redirect_to root_path, alert: "You are not authorized to access this photo."
          return
        end
      else
        Photo.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.require(:photo).permit(:title, :description, :image, :photo_sharing, :image_cache)
    end
end

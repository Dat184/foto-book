class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :set_photos, only: %i[ new edit create update ]

  # GET /albums or /albums.json
  def index
    @pagy, @albums = pagy(:countless, Album.public_albums.includes(:photos, :user).order(created_at: :desc), limit: 6)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def feed
    @pagy, @albums = pagy(:countless, Album.public_albums_from_following(current_user).includes(:photos, :user).order(created_at: :desc), limit: 6)

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  def discovery
    @pagy, @albums = pagy(:countless, Album.public_albums.includes(:photos, :user).order(created_at: :desc), limit: 6)

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = current_user.albums.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = current_user.albums.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to profile_path(tab: "albums"), notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        flash.now[:alert] = @album.errors.full_messages.to_sentence.presence || "Create failed. Please check the form."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to profile_path(tab: "albums"), notice: "Album was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @album }
      else
        flash.now[:alert] = @album.errors.full_messages.to_sentence.presence || "Update failed. Please check the form."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy!

    respond_to do |format|
      format.html { redirect_to profile_path(tab: "albums"), notice: "Album was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = if user_signed_in?
        begin
          current_user.albums.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          redirect_to root_path, alert: "You are not authorized to access this album."
          return
        end
      else
        Album.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.expect(album: [ :title, :description, :album_sharing, photo_ids: [] ])
    end

    def set_photos
      @photos = current_user.photos
    end
end

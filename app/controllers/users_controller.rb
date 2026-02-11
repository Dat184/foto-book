class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[update ]
  before_action :authorize_user_edit!, only: %i[update ]

  # GET /profile
  def profile
    @user = current_user
    @is_my_profile = true
    @active_tab = params[:tab] || "photos"
    render :profile
  end

  # GET /profile/edit
  def edit_profile
    @user = current_user
    render :edit_profile
  end

  # GET /users/:id/profile
  def public_profile
    @user = User.find(params[:id])
    if @user == current_user
      @is_my_profile = true
    else
      @is_my_profile = false
    end
    @active_tab = params[:tab] || "photos"
    render :profile
  end

  # POST /users/:id/follow
  def follow
    @user = User.find(params[:id])
    unless current_user == @user || current_user.following.include?(@user)
      current_user.following << @user
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to request.referer, notice: "You are now following #{@user.firstName}" }
    end
  end

  # DELETE /users/:id/unfollow
  def unfollow
    @user = User.find(params[:id])
    current_user.following.delete(@user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to request.referer, notice: "You have unfollowed #{@user.firstName}" }
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_path, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :profile, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def authorize_user_edit!
      return if current_user.role_admin? || @user == current_user

      redirect_to profile_path, alert: "Not authorized"
    end

    # Only allow a list of trusted parameters through.
    def user_params
      # params.expect(user: [ :firstName, :lastName, :email, :avatar ])
      params.require(:user).permit(:firstName, :lastName, :email, :avatar)
    end
end

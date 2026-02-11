module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[ destroy edit update ]
    before_action :authorize_admin!
    def index
      @pagy, @users = pagy(User.role_user.order(created_at: :desc), limit: 10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        if @user.status_previously_changed? && @user.status == "inactive"
          UserMailer.inactive_mail(@user).deliver_now
        end
        redirect_to admin_users_path, notice: "Update user successfully!"
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        UserMailer.delete_mail(@user).deliver_now
        redirect_to admin_users_path, notice: "Delete user successfully!"
      else
        redirect_to admin_users_path, notice: "Failed to delete user."
      end
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        # params.expect(user: [ :firstName, :lastName, :email, :avatar ])
        params.require(:user).permit(:firstName, :lastName, :email, :avatar, :status)
      end
  end
end

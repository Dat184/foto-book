module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[ destroy ]
    def index
      @pagy, @users = pagy(User.role_user.order(created_at: :desc), limit: 10)
    end

    def edit
      
    end

    def update

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
  end
end

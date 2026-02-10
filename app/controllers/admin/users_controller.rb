module Admin
  class UsersController < ApplicationController
    def index
      @pagy, @users = pagy(User.all)
    end
  end
end

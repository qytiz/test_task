class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    result = Users::Create.run(params: user_params)
    
    redirect_to users_path unless result
  end

  def new
    @user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  private
  def user_params
      params.require(:user).permit(
        :surname, 
        :name, 
        :patronymic, 
        :email, 
        :age, 
        :nationality, 
        :country, 
        :gender, 
        :interests, 
        :skills
      )
  end
end

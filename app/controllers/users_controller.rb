# frozen_string_literal: true

class UsersController < ApplicationController
  USER_PARAMS = %i[surname name patronymic email age nationality country gender interests skills].freeze
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    result = Users::Create.run(params: user_params)

    if result.valid?
      redirect_to users_path, notice: 'Пользователь успешно создан'
    else
      flash[:error] = result.errors.full_messages.join(', ')
      render :new
    end
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
      *USER_PARAMS,
      interests: [],
      skills: []
    )
  end
end

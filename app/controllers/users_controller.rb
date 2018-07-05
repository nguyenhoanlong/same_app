class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy following followers)
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: :destroy
  before_action :load_user, only: %i(show edit update)

  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def following
    @title = t "shared.following"
    @user  = User.find params[:id]
    @users = @user.following.page params[:page]
    render :show_follow
  end

  def followers
    @title = t "shared.followers"
    @user  = User.find params[:id]
    @users = @user.followers.page params[:page]
    render :show_follow
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.create.confirm_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    render html: (t "notFound") if @user.nil?
    @microposts = @user.microposts.page params[:page]
  end

  def edit
    render html: (t "notFound") if @user.nil?
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".titleUpdate"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    user = User.find_by id: params[:id]
    user.destroy
    flash[:success] = t ".success"
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end
end

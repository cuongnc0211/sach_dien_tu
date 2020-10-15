class Admin::UsersController < Admin::BaseController
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where.not(role: :super_admin).page(params[:page]).per 10
  end

  def show
  end

  def edit
  end

  def new
    @user = User.new
  end

  def update
    if @user.update user_params
      flash[:success] = "Updated user"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Update user fail"
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "Created user"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Creat user fail"
      render :new
    end
  end

  def destroy
    if @user.books.blank? && @user.delete
      flash[:success] = "Deleted user"
    else
      flash[:danger] = "delete user fail"
    end
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = User.where.not(role: :super_admin).find params[:id]
  end

  def user_params
    params.require(:user).permit :email, :password, :name, :avatar
  end
end

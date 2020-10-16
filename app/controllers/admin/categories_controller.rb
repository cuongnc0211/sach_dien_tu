class Admin::CategoriesController < Admin::BaseController
  before_action :load_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.page(params[:page]).per 20
  end

  def show
  end

  def edit
  end

  def new
    @category = Category.new
  end

  def update
    if @category.update category_params
      flash[:success] = "Updated category"
      redirect_to admin_category_path(@category)
    else
      flash.now[:danger] = "Update category fail"
      render :edit
    end
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = "Created category"
      redirect_to admin_category_path(@category)
    else
      flash.now[:danger] = "Creat category fail"
      render :new
    end
  end

  def destroy
    if @category.books.blank? && @category.delete
      flash[:success] = "Deleted category"
    else
      flash[:danger] = "delete category fail"
    end
    redirect_to admin_categories_path
  end

  private

  def load_category
    @category = Category.find params[:id]
  end

  def category_params
    params.require(:category).permit :name, :description
  end
end

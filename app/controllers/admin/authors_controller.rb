class Admin::AuthorsController < Admin::BaseController
  before_action :load_author, only: [:show, :edit, :update, :destroy]

  def index
    @authors = Author.all.page(params[:page]).per 20
  end

  def show
  end

  def edit
  end

  def new
    @author = Author.new
  end

  def update
    if @author.update author_params
      flash[:success] = "Updated author"
      redirect_to admin_author_path(@author)
    else
      flash.now[:danger] = "Update author fail"
      render :edit
    end
  end

  def create
    @author = Author.new author_params
    if @author.save
      flash[:success] = "Created author"
      redirect_to admin_author_path(@author)
    else
      flash.now[:danger] = "Creat author fail"
      render :new
    end
  end

  def destroy
    if @author.books.blank? && @author.delete
      flash[:success] = "Deleted author"
    else
      flash[:danger] = "delete author fail"
    end
    redirect_to admin_authors_path
  end

  private

  def load_author
    @author = Author.find params[:id]
  end

  def author_params
    params.require(:author).permit :full_name, :birth_day, :nationality
  end
end

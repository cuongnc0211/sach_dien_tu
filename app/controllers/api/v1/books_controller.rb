module Api
  module V1
    class BooksController < ApiController
      def index
        books = ::Book.all.order(created_at: :desc).page(params[:page]).per params[:limit]

        render json: books,
               each_serializer: ::Books::IndexSerializer,
               root: "books", include: '**',
               meta: meta_attributes(books), meta_key: 'pages',
               status: 200
      end
    end
  end
end
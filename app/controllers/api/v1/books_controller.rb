module Api
  module V1
    class BooksController < ApiController
      DEFAULT_LIMIT = 20

      def index
        limit = DEFAULT_LIMIT || params[:limit]
        binding.pry
        books = ::Book.all.order(created_at: :desc).page(params[:page]).per limit

        render json: books,
               each_serializer: ::Books::IndexSerializer,
               include: '**',
               success: true,
               status: 201
      end
    end
  end
end
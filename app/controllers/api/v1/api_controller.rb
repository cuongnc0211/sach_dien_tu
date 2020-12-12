module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: {
          messages: exception.message,
          success: :fail,
        }, status: 404
      end
    
      protected
    
      def meta_attributes(collection, extra_meta = {})
        {
          current_page: collection.try(:current_page),
          next_page: collection.try(:next_page),
          prev_page: collection.try(:prev_page), # use collection.previous_page when using will_paginate
          total_pages_count: collection.try(:total_pages),
          total_count: collection.try(:total_count)
        }.merge(extra_meta)
      end
    end
  end
end

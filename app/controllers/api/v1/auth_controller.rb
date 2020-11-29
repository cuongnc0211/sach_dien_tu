module Api
  module V1
    class AuthController < ApiController
      before_action :authen_request

      private

      def authen_request
        load_user(bearer_token)
        return if @current_use.present?

        render json: { success: :false, code: 401 }, status: :unauthorized
      end

      def bearer_token
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        header.gsub(pattern, '') if header && header.match(pattern)
      end

      def load_user(token)
        id = Auth.decode(token)[:id]
        @current_user = User.find_by id: id
      end
    end
  end
end

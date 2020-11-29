module Api
  module V1
    class SessionsController < ApiController
      before_action :check_existed_email, :check_mathch_password, only: :sign_up

      def sign_in
        user = ::User.find_by(email: params[:email])
        if user.present? && user.valid_password?(params[:password])
          render json: user,
                 serializer: UserLoginSerializer,
                 success: true,
                 status: 201
        else
          render json: {errors: 'Email or password not correct!'},
                 success: false,
                 status: 400
          end
      end

      def sign_up
        session_params.merge!(role: :user)
        user = ::User.new(session_params)
        if user.save
          render json: user,
                 serializer: UserSerializer,
                 success: true,
                 status: 201
        else
          render json: user,
                 serializer: UserSerializer,
                 success: false,
                 status: 400
        end
      end

      def refresh_token
      end

      private

      def session_params
        params.require("user").permit :email, :password, :name, :avatar
      end

      def check_existed_email
        user = ::User.find_by(email: params[:user][:email])
        return if user.nil?

        render json: {errors: 'Email existed'},
               success: false,
               status: 400
      end

      def check_mathch_password
        return if params[:user][:password] == params[:user][:retype_password]

        render json: {errors: 'Password not match'},
               success: false,
               status: 400
      end
    end
  end
end


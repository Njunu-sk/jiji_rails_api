module Api
  module V1
    class ApiController < ActionController::API
      include Response
      include ExceptionHandler
      before_action :authorize_request
      attr_reader :current_user

      private

      def authorize_request
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { message: "Expired token, Please sign in"} if token.blank? || expired_token?(token)

        @current_user = ::User::AuthorizeApiRequest.new(request.headers).call.compact.values.first
      end

      def expired_token?(token)
        JwtDenylist.exists?(jwt: token)
      end
    end
  end
end

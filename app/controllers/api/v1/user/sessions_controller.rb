module Api
  module V1
    module User
      class SessionsController < Api::V1::ApiController
        skip_before_action :authorize_request, only: :create

        def create
          auth_token = ::AuthenticateUser.new(login_params[:email], login_params[:password]).call
          current_user = ::CurrentUser.new(auth_token).call[:user] if auth_token
          if current_user
            filtered_user = current_user.as_json(except: %i[password_digest])
            if current_user
              render json: { data: { user: filtered_user } , token: auth_token },
                    status: :ok
            end
          else
            json_response({ errors: current_user.errors.full_messages }, :unprocessable_entity)
          end
        end

        private

        def login_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end

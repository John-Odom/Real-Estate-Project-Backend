class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
      # hiding secret in a randomly generated string
      JWT.encode(payload, 'uu4TvbVukXgpKqC9l20c')
    end
   
    def auth_header
      request.headers['Authorization']
    end
   
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, 'uu4TvbVukXgpKqC9l20c', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
   
    def current_user
      if decoded_token
        # decoded_token=> [{"user_id"=>2}, {"alg"=>"HS256"}]
        # or nil if we can't decode the token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end
    end
   
    def logged_in?
      !!current_user
    end
  end
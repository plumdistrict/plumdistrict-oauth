require 'rest_client'

module PlumDistrict
  class OAuth
    # API application ID registered at plumdistrict
    @client_id     = nil

    # API secret code registered at plumdistrict
    @client_secret = nil

    # Authorization endpoint that returns a new token for a user
    @authorize_url = 'https://www.plumdistrict.com/api/v2/oauth/authenticate.json'

    # Revoke a user's token endpoint
    @revoke_url    = 'https://www.plumdistrict.com/api/v2/oauth/revoke.json'

    # Retrieve user information endpoint
    @user_info_url = 'https://www.plumdistrict.com/api/v2/oauth/users/show.json'

    class << self

      attr_accessor :client_id, :client_secret, :authorize_url, :revoke_url, :user_info_url

      # Authorize the user against plumdistrict and get an oAuth token for the user
      #
      # @param [String] email the users email address
      # @param [String] password the users password
      # @return [Hash] parsed json string that contains the token or error messages
      #
      def authorize_user(email, password)
        params = { email: email, password: password }
        api_post(@authorize_url, @client_id, params)
      end

      # Get user information for a user's token
      #
      # @param [String] user_oauth_token
      # @return [Hash] parsed json string that contains user information
      #
      def user_info(user_oauth_token)
        api_post(@user_info_url, user_oauth_token)
      end

      # Revoke a user's token making it no longer usable
      #
      # @param [String] user_oauth_token
      # @return [Hash] parsed json string that contains user information
      #
      def revoke_user(user_oauth_token)
        params = { token: user_oauth_token }
        api_post(@revoke_url, @client_id, params)
      end

      protected

      # Send post to plumdistrict
      #
      # @param [String] url plumdistrict API end point
      # @param [String] oauth_token plumdistrict oauth access token for header
      # @param [Hash] params variables to send to plumdistrict
      # @return [Hash] parsed json string that contains result or error messages
      #
      def api_post(url, oauth_token, params = {})
        RestClient.reset_before_execution_procs
        RestClient.add_before_execution_proc do |req, _|
          req["Authorization"] = "OAuth #{ oauth_token }"
        end
        send_params = { client_id: @client_id, client_secret: @client_secret }.merge(params)
        result      = RestClient.post url, send_params.to_json, content_type: :json, accept: :json
        case response.code
          when 200
            JSON.parse(result.body)["response_data"]
          else
            { error: JSON.parse(result.body), status: result.code }
        end
      rescue RestClient::Exception => e
        if e.response.code < 400
          { error: JSON.parse(e.response.body), status: e.response.code }
        else
          { error: JSON.parse(e.response.body), status: e.response.code }
        end
      end

    end # end class functions

  end
end

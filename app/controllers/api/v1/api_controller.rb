module Api
  module V1
    class ApiController < ApplicationController
      skip_before_action :verify_authenticity_token, :if => proc { |c| c.request.format == 'application/json' }
      before_action :validate_token
      respond_to :json

      def stack_complete
        logger.info 'inside stack_complete'
        return head :unprocessable_entity unless params.has_key?(:aws_values)

        aws_values = JSON.parse(params[:aws_values], :quirks_mode => true)

        Rails.logger.error aws_values.to_s
        return head :unprocessable_entity unless aws_values.respond_to?('each')
        return head :unprocessable_entity unless aws_values.has_key?('stack_id')

        stack_id = aws_values['stack_id']

        results = { 'error' => nil, 'stack_id': stack_id }
        respond_json(results)
      end

      private

      def respond_json(records)
        respond_to do |format|
          format.json do
            render plain: records.to_json, content_type: 'application/json'
          end
        end
      end

      def validate_token
        return head :unauthorized unless params.has_key?(:token)
        token = params[:token]
        # We don't need any specific token or user, yet.
        # if we do, we need a model to hold the tokens and a GUI to generate them.
        # I do not expect to issue tokens to end users, so all tokens can be admin

        # @auth_user = Apikey.auth_user(token)
        # return head :unauthorized if @auth_user.nil?
        # @auth_user
      end
    end
  end
end

module BuilderJsonWebToken
  class JsonWebToken
    attr_reader :id, :expiration, :interview_id, :admin_id, :auth_admin_id

    class << self
      def encode(id, user_type, data = {}, expiration = nil)
        expiration, data = data, expiration unless data.is_a?(Hash)

        data       ||= {}
        expiration ||= 24.hours.from_now if user_type == 'app_user'
        expiration ||= 72.hours.from_now if user_type == 'interviewer'
        expiration ||= 30.minutes.from_now if user_type == 'admin'
        expiration ||= 5.minutes.from_now if user_type == 'admin_otp'

        payload = build_payload_for(id.to_i, user_type, data, expiration.to_i)

        JWT.encode payload, secret_key, algorithm
      end

      def decode(token)
        JsonWebToken.new token_data_for(token)
      end

      private

      def token_data_for(token)
        JWT.decode(token, secret_key, true, {
          :algorithm => algorithm,
        })[0]
      end

      def build_payload_for(id, user_type, data, expiration)
        if user_type == 'app_user'
          {
            :id  => id,
            :exp => expiration,
          }.merge(data)
        elsif user_type == 'interviewer'
          {
            :interview_id  => id,
            :exp => expiration,
          }.merge(data)
        elsif user_type == 'admin'
          {
            :admin_id  => id,
            :exp => expiration,
          }.merge(data)
        elsif user_type == 'admin_otp'
          {
            :auth_admin_id  => id,
            :exp => expiration,
          }.merge(data)
        end
      end

      def secret_key
        @secret_key ||= Rails.application.secret_key_base
      end

      def algorithm
        'HS512'
      end
    end

    def initialize(data)
      @id = data.delete('id')
      @expiration = Time.at(data.delete('exp')).to_time
      @struct = nil
      @interview_id = data.delete('interview_id')
      @admin_id = data.delete('admin_id')
      @auth_admin_id = data.delete('auth_admin_id')

      initialize_attributes_for data if data.is_a?(Hash) && data.keys.any?
    end

    private

    def initialize_attributes_for(data)
      @struct = Struct.new(*data.keys.map(&:to_sym)).new
      data.keys.each do |key|
        @struct.send("#{key}=", data[key])
      end
    end

    def respond_to_missing?(method, *args)
      super || @struct.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      return @struct.send(method) if @struct.respond_to?(method)
      super
    end
  end
end

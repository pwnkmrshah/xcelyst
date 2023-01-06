# frozen_string_literal: true

RSpec.shared_context(:jwt) do
  let(:jwt) { BuilderJsonWebToken.encode id }

  let(:jwt_expired) do
    token = BuilderJsonWebToken.encode(id, Time.now + 0.01)
    sleep 0.02
    token
  end
end

RSpec.configure do |config|
  config.include_context :jwt, :jwt => true
end

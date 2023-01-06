module BuilderJsonWebToken
  module Core
    extend self

    def encode(*args)
      JsonWebToken.encode(*args)
    end

    def decode(*args)
      JsonWebToken.decode(*args)
    end
  end
end

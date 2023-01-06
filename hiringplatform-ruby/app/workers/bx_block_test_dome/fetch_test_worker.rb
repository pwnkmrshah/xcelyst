module BxBlockTestDome
	class FetchTestWorker
		include Sidekiq::Worker

		def perform(*args)
      url = Rails.application.routes.default_url_options[:host] + "/bx_block_test_dome/test_domes"
      response = send_post_request(url,{})
      JSON.parse(response.body) if response.body
      puts "===============#{url}=============="
      puts "============================="
      puts response
		end

    def send_post_request(uri, data)
      url   = URI(uri)
      http  = Net::HTTP.new(url.host, url.port)
      http.use_ssl      = true
      http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Post.new(url)
      request["content-type"]   = 'application/json'
      request["cache-control"]  = 'no-cache'
      request.body = data.to_json
      http.request(request)
    end

	end
end

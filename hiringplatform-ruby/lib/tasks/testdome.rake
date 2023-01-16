namespace :test do
  desc 'Update test data'
  task update_test_data: :environment do
    # rake test:update_test_data
    # Call Internal URL
    # if Rails.env == "development"
    #   url = "https://hiringplatform-74392-ruby.b74392.dev.us-east-1.aws.svc.builder.cafe/bx_block_test_dome/test_domes"
    # elsif Rails.env == "staging"
    #   url = "https://hiringplatform-74392-ruby. b74392.stage.eastus.az.svc.builder.ai/bx_block_test_dome/test_domes"
    # elsif Rails.env = "production"
    #   url = "https://hiringplatform-74392-ruby.b74392.stage.eastus.az.svc.builder.ai/bx_block_test_dome/test_domes"
    # end
    url = Rails.application.routes.*[:host] + "/bx_block_test_dome/test_domes"
    response = send_post_request(url,{})
    JSON.parse(response.body) if response.body
    puts "============================="
    puts response
  end

  def send_post_request(uri, data)
    url   = URI(uri)
    http  = Net::HTTP.new(url.host, url.port)
    http.use_ssl      = false
    http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
    request           = Net::HTTP::Post.new(url)
    request["content-type"]   = 'application/json'
    request["cache-control"]  = 'no-cache'
    request.body = data.to_json
    http.request(request)
  end
end
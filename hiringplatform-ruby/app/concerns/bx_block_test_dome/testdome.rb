module BxBlockTestDome
  module Testdome
    extend ActiveSupport::Concern

    def get_auth_token
      uri = URI.parse("https://testdome.com/api/v1/token")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
       
      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' # use your service key here
      }

      data = {
        grant_type: "password",
        username: "namita.akhauri@xcelyst.com",
        password: "BqeGCfKp0NiyblzyCXyx"
      }.to_json
       
      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      # req.body = data
      req.set_form_data( grant_type: "password", username: "namita.akhauri@xcelyst.com", password: "BqeGCfKp0NiyblzyCXyx")
      res = https.request(req)
      responsee = JSON.parse(res.body)
      auth = responsee['access_token']
      return auth
    end

    def send_get_request req_url, data, auth_token
      uri2 = URI.parse(req_url)
      https = Net::HTTP.new(uri2.host,uri2.port)
      https.use_ssl = true
       
      headers2 = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + auth_token
      }

      request = Net::HTTP::Get.new(uri2.path, initheader = headers2)
      request.set_form_data = data if data.present?
      res2 = https.request(request)
      JSON.parse(res2.body)
    end
  end  
end
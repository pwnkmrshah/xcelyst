require 'uri'
require 'net/http'
require 'net/https'
require 'base64'
require 'json'
module BxBlockSovren
  class SampleParsingApi

    attr_accessor :resume_file

    def initialize resume_file
      @resume_file = resume_file
    end

    def execute
      file_path = resume_file
      file_data = IO.binread(file_path)
      modified_date = File.mtime(file_path).to_s[0,10]
       
      # Encode the bytes to base64
      base_64_file = Base64.encode64(file_data)

      data = {
        "DocumentAsBase64String" => base_64_file,
        "DocumentLastModified" => modified_date
      }.to_json
       
      uri = "https://eu-rest.resumeparsing.com/v10/parser/resume"
      respObj = send_post_req uri, data

    end

    def send_post_req url, data
      uri = URI.parse("#{url}")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true

      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Sovren-AccountId' => ENV['SOVREN_ID'] || '14044560', # use your account id here
        'Sovren-ServiceKey' => ENV['SOVREN_KEY'] || 'qQ8I+UkWFIRC0p9fx0GDq5wDCAw75mgNJERyB+RO', # use your service key here
      }

      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      req.body = data
      res = https.request(req)
       
      respObj = JSON.parse(res.body)
    end


  end
end
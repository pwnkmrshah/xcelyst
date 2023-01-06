module BxBlockTestDome
  class TestDomesController < ApplicationController
    include BxBlockTestDome::Testdome
    
    require 'uri'
    require 'net/http'
    require 'net/https'
    require 'base64'
    require 'json'

    def create
     auth_token = get_auth_token
      result = send_get_request("https://testdome.com/api/v1/tests", {}, auth_token)
      render json: result
      if result.present?
        result.each do |info|
          # save Candidates
         
          uri2 = URI.parse("https://testdome.com/api/v1/candidates")
          https = Net::HTTP.new(uri2.host,uri2.port)
          https.use_ssl = true
           
          headers2 = {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer ' + auth_token
          }

          request = Net::HTTP::Get.new(uri2.path, initheader = headers2)
          request.set_form_data( testId: info["id"])
          res2 = https.request(request)
          result2 = JSON.parse(res2.body)
          result2.each do |user|
            user_email =  user["email"]
            acc = AccountBlock::Account.find_by(email: user_email, user_role: "candidate")
            if acc.present?
              test_data = acc.test_score_and_courses.find_by(test_id: info["id"])
              if test_data
                score = user["testScore"] || test_data.score
                test_url = user["reportUrl"] || test_data.test_url
                invitation_end_date = user["invitationEndDate"] || test.invitation_end_date
                test_data.update(score: score, status: user["status"], description: info["description"], test_url: test_url, invitation_end_date: invitation_end_date)
              else
                test_data = BxBlockProfile::TestScoreAndCourse.create(
                  test_id: info["id"],
                  test_url: user["reportUrl"],
                  title: info["name"],
                  invitation_end_date: user["invitationEndDate"],
                  score: user["testScore"], 
                  status: user["status"], 
                  description: info["description"]
                )
                BxBlockProfile::TestAccount.find_or_create_by(test_score_and_course_id: test_data.id, account_id:acc.id)
              end
            end
          end
        end
      end
    end

    def index
      accounts = AccountBlock::Account.find(BxBlockProfile::TestAccount.all.pluck(:account_id))
      if accounts.present?

        render :json => {
          status_code: 200,
          message: "accounts for tests",
          data:
          {
            accounts: accounts.map{ |acc|
              {
                id: acc.id,
                full_name: acc.first_name,   
                candidate_role: acc.roles,           
                test_data: acc.test_score_and_courses
              }
            }
          }
        }, status: 200
      else
        render json:  { success: false, status: 404,  errors:  [{message: 'Record Not Found' }] }
      end
    end


    def delete_all
      begin
        BxBlockProfile::TestAccount.all.delete_all
        # BxBlockProfile::TestScoreAndCourse.all.delete_all
        render json: {message: "success"}, status: 200
      rescue => exception
        render json: {message: exception}, status: 200
      end
    end

  end
end    
    
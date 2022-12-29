module BxBlockRolesPermissions
  class AppliedJobsController < ApplicationController
    before_action :check_client_role, except: [:create]
    before_action :check_jd_exist?, only: :create
    
    # Create by Punit
    # Method for creating a applied_job for a role and also create a shorlist Cadndidate
    def create
      @shortlist = BxBlockShortlisting::ShortlistingCandidate.new(applied_job_params.merge!(client_id: @jd.role.account_id, candidate_id: current_user.id, is_applied_by_candidate: true,
                                                                                            shortlisted_by_admin: "false", is_shortlisted: false))
      if @shortlist.save
        @applied_job = BxBlockRolesPermissions::AppliedJob.create(profile_id: current_user.profile.id, role_id: @jd.role.id, shortlisting_candidate_id: @shortlist.id)
        # update sovren score for candidates
        update_sovren_score(@shortlist, @jd)

        # send emails
        BxBlockProfile::ApplyForJobMailer.with(job: @shortlist, host: request.base_url).job_applied.deliver_now
        BxBlockProfile::ApplyForJobMailer.with(email: current_user.email).apply_for_job.deliver_now
        render json: { message: "Successfully applied for a job." }, status: 200
      else
        render json: { errors: @shortlist.errors.full_messages }, status: 422
      end
    end

    # created by punit
    # client accept or reject to candidated for  job
    def proceed
      appied_job = BxBlockRolesPermissions::AppliedJob.find_by(role_id: params[:role_id], profile_id: params[:profile_id])
      return render json: {errors: "Please Give Final Score"}, status: :unprocessable_entity unless appied_job.final_score.present?
        if params[:accepted]
          appied_job.update(accepted: params[:accepted], status: "accepted")
        else
          appied_job.update(accepted: params[:accepted], status: "rejected")
        end
      render json: BxBlockRolesPermissions::ApplyCandidateSerializer.new(appied_job).serializable_hash, status: :ok
    end

    # Create by Punit 
    # Clinet and Search Applied Candidates Usign the Role id or First Name 
    def applied_user_search
      account = AccountBlock::Account.joins(profile: [:applied_jobs]).where("first_name LIKE ?", "%#{params[:first_name]}%").where(applied_jobs: { role_id: params[:role_id] })
      if account.length > 0
        render json: BxBlockScheduling::CandidateProfileSerializer.new(account), status: :ok
      else
        render json: { errors: "data not found" }, status: :unprocessable_entity
      end
    end

    private

    def applied_job_params
      params.require(:applied_job).permit(:job_description_id)
    end

    def check_jd_exist?
      @jd = BxBlockJobDescription::JobDescription.find_by(id: applied_job_params[:job_description_id])
      unless @jd.present?
        return render json: { error: "Job doesn't exist." }, status: 404
      end
    end

    def update_sovren_score(shortlist_candidate, jd)
      user = BxBlockShortlisting::ShortlistingCandidate.find_by(job_description_id: jd&.id, candidate_id: shortlist_candidate&.candidate_id)
      candidate = AccountBlock::Account.find(shortlist_candidate&.candidate_id)
      # ======================================================================================
      # For Fetch a score from sovren
      # ======================================================================================
      # doc_id = "#{@user_resume.document_id}".downcase
      uri = "https://eu-rest.resumeparsing.com/v10/matcher/indexes/1/documents/#{candidate&.document_id}"
      data =  { "IndexIdsToSearchInto" => [ "jd001" ], FilterCriteria: { DocumentIds: ["#{jd&.document_id}"]} }.to_json
      score_rs = send_post_req uri,data
      print "========#{jd&.document_id}============================================"
      # TO STORE A SOVREN SCORE IN THE TABLE
      if score_rs.present?
        if score_rs["Value"]["Matches"].present?
          score_rs["Value"]["Matches"].each do |jd_id|
            if user.present?
              user.update(sovren_score: jd_id['SovScore'])
            end  
          end  
        end
      end
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
      # Parse the response body into an object
      respObj = JSON.parse(res.body) if res.body.present? && res.msg == "OK"
    end 
  end
end

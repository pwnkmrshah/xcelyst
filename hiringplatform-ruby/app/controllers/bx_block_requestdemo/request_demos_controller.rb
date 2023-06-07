module BxBlockRequestdemo
	class RequestDemosController < ApplicationController
		
		def create
			demo = RequestDemo.new(demo_params)
			if demo.save
				if demo.email.present?
					# BxBlockRequestdemo::RequestDemoMailer.with(email: demo.email).contact_you.deliver_now
					BxBlockRequestdemo::RequestDemoMailer.with(demo).admin_inform.deliver_now
				end
				render json: { message: "A Member of the Team Will be in Contact With you" }, status: 200
			else
				render json: { errors: demo.errors.full_messages }, status: 422
			end
		end

		private

    def demo_params
        params.require(:request_demo).permit(:first_name, :last_name, :phone_no, :email, :company_name)
    end
  end
end
    

		

	


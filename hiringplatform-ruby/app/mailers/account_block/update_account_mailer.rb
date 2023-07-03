module AccountBlock
    class UpdateAccountMailer < ApplicationMailer
      def update_pic
        fetch_email('update_profile', @record.email)
      end

      def update_profile
        fetch_email('update_profile', @record.email)
      end

      private


   end
end
  
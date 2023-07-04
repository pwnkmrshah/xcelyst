module AccountBlock
    class UpdateAccountMailer < ApplicationMailer
      def update_pic
        fetch_email(@record.email)
      end

      def update_profile
        fetch_email(@record.email)
      end

      private


   end
end
  
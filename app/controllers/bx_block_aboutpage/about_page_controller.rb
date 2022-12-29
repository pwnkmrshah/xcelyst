module BxBlockAboutpage
  class AboutPageController < ApplicationController

    # created by punit
    # send the About page content.
    def show
      content = AboutPage.all
      content_type = BxBlockContentManagement::ContentType.where(type: "MemberBio")
      management_team = content_type.where(name: "Management Team")[0].member_bio rescue 0
      advisory_board = content_type.where(name: "Advisory Board")[0].member_bio rescue 0
      if content.present? || management_team.present? || advisory_board.present?
        render json: { data: {
                 content: content.as_json(only: [:id, :title, :description, :image]),
                 management_team: management_team.as_json(only: [:id, :name, :description, :position, :order, :facebook_link, :linkedin_link, :twitter_link, :image]),
                 advisory_board: advisory_board.as_json(only: [:id, :name, :description, :position, :order, :facebook_link, :linkedin_link, :twitter_link, :image]),
                 location_addresses: BxBlockAddress::LocationAddressSerializer.new(BxBlockAddress::LocationAddress.all).serializable_hash[:data]
               } }, status: 200
      else
        render json: { errors: "Data not Found" }, status: 422
      end
    end

    def page_preview
      data = BxBlockAboutpage::AboutPage.find(params[:id])
      if data.present?
        render json: { data: data }, status: 200
      else
        render json: { message: "Record not found" }, status: :not_found
      end
    end

  end
end

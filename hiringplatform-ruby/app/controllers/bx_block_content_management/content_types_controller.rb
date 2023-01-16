module BxBlockContentManagement
  class ContentTypesController < ApplicationController
    # skip_before_action :validate_json_web_token, only: [:index]

    def show
      content_types = BxBlockContentManagement::ContentType.all.order(:rank).page(params[:page]).per(params[:per_page])
      render json: BxBlockContentManagement::ContentTypeSerializer.new(content_types).serializable_hash, status: :ok
    end

    #created by punit
    #send content data useing content type name 
    def get_data 
      if params[:name]
        content_type =  BxBlockContentManagement::ContentType.find_by(name: params[:name])
        case content_type.type
        when "Text"
          content_text = content_type.content_text
          if content_text
            render json: {data: content_text.as_json(only: [:id, :headline, :synopsis, :content, :affiliation,  :hyperlink, :images])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "Videos"
          content_video = content_type.content_video.where(active: true)
          unless content_video.length >= 2
            video = BxBlockContentManagement::ContentVideo.where.not(video_url: nil).order("created_at ASC")
            content_video = video.last(2)
          end
          if content_video
            render json: {data: content_video.as_json(only: [:id, :separate_section, :headline, :description, :thumbnails, :image, :video_url])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "AudioPodcast"
          audio_podcast = content_type.audio_podcast
          if audio_podcast
            render json: {data: audio_podcast.as_json(only: [:id, :heading, :description, :image, :audio_url])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "Epub"
          epub = content_type.epub
          if epub
            render json: {data: epub.as_json(only: [:id, :heading, :description, :pdfs])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "MemberBio"
          member_bio = content_type.member_bio
          if member_bio
            render json: {data: member_bio.as_json(only: [:id, :name, :description, :position, :social_media_links, :image])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        else
          render json: {error: "content not found"}, status: :unprocessable_entity
        end
      else
        render json: {errors: "params not found"}, status: :unprocessable_entity
      end
    end

    #created by punit
    #send content data useing content id or type
    def get_content
      if params[:type] && params[:content_id]
        case params[:type]
        when "Text"
          content_text = BxBlockContentManagement::ContentText.find_by(id: params[:content_id])
          if content_text
            render json: {data: content_text.as_json(only: [:id, :headline, :synopsis, :content, :affiliation,  :hyperlink, :images])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "Videos"
          content_video = BxBlockContentManagement::ContentVideo.find_by(id: params[:content_id])
          if content_video
            render json: {data: content_video.as_json(only: [:separate_section, :headline, :description, :thumbnails, :image, :video_url])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "AudioPodcast"
          audio_podcast = BxBlockContentManagement::AudioPodcast.find_by(id: params[:content_id])
          if audio_podcast
            render json: {data: audio_podcast.as_json(only: [:heading, :description, :image, :audio_url])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "Epub"
          epub = BxBlockContentManagement::Epub.find_by(id: params[:content_id])
          if epub
            render json: {data: epub.as_json(only: [:heading, :description, :pdfs])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        when "MemberBio"
          member_bio = BxBlockContentManagement::MemberBio.find_by(id: params[:content_id])
          if member_bio
            render json: {data: member_bio.as_json(only: [:name, :description, :position, :social_media_links, :image])}
          else
            render json: {error: "content not found"}, status: :unprocessable_entity
          end
        else
          render json: {error: "content type not valid"}, status: :unprocessable_entity
        end
      else
        render json: {errors: "params not found"}, status: :unprocessable_entity
      end
    end

    def get_banner
      banner = BxBlockContentManagement::HomePage.where(active: true)
      if banner.present? && banner.length > 0
        render json: {data: banner.as_json(only: [:title, :description, :image])}
      else
        render json: {errors: "banner not found"}, status: :unprocessable_entity
      end
    end


    def get_social_media_link
      links = SocialMediaLink.all
      render json: {data: links}, status: :ok
    end
  end
end

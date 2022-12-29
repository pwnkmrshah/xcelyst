##
# This code was generated by
# \ / _    _  _|   _  _
#  | (_)\/(_)(_|\/| |(/_  v1.0.0
#       /       /
#
# frozen_string_literal: true

module Twilio
  module REST
    class Media
      class V1 < Version
        ##
        # Initialize the V1 version of Media
        def initialize(domain)
          super
          @version = 'v1'
          @media_processor = nil
          @player_streamer = nil
        end

        ##
        # @param [String] sid The SID of the MediaProcessor resource to fetch.
        # @return [Twilio::REST::Media::V1::MediaProcessorContext] if sid was passed.
        # @return [Twilio::REST::Media::V1::MediaProcessorList]
        def media_processor(sid=:unset)
          if sid.nil?
              raise ArgumentError, 'sid cannot be nil'
          end
          if sid == :unset
              @media_processor ||= MediaProcessorList.new self
          else
              MediaProcessorContext.new(self, sid)
          end
        end

        ##
        # @param [String] sid The SID of the PlayerStreamer resource to fetch.
        # @return [Twilio::REST::Media::V1::PlayerStreamerContext] if sid was passed.
        # @return [Twilio::REST::Media::V1::PlayerStreamerList]
        def player_streamer(sid=:unset)
          if sid.nil?
              raise ArgumentError, 'sid cannot be nil'
          end
          if sid == :unset
              @player_streamer ||= PlayerStreamerList.new self
          else
              PlayerStreamerContext.new(self, sid)
          end
        end

        ##
        # Provide a user friendly representation
        def to_s
          '<Twilio::REST::Media::V1>'
        end
      end
    end
  end
end
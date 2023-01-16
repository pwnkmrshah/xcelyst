# frozen_string_literal: true

module BxBlockPrivacySettings
  class PrivacySettingsController < ApplicationController
    before_action :load_account_setting
    before_action :check_account_activated

    def show_setting
      return if @account_setting.nil?

      serializer = BxBlockPrivacySettings::PrivacySettingSerializer.new(@account_setting)
      render json: serializer.serializable_hash,
             status: :ok
    end

    def activities
      return if @account_setting.nil?

      serializer = BxBlockPrivacySettings::ActivitySettingSerializer.new(@account_setting)
      render json: serializer.serializable_hash,
             status: :ok
    end

    def push_notifications
      return if @account_setting.nil?

      serializer = BxBlockPrivacySettings::NotificationSettingSerializer.new(@account_setting)
      render json: serializer.serializable_hash,
             status: :ok
    end

    def update_activity
      return if @account_setting.nil?

      if @account_setting.update(activity_params)
        serializer = BxBlockPrivacySettings::ActivitySettingSerializer.new(@account_setting)
        render json: serializer.serializable_hash,
               status: :ok
      else
        render json: { errors: @account_setting.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def update_push_notification
      return if @account_setting.nil?

      if notification_params[:off_all_notification]
        @account_setting.update(in_app_notification: false, chat_notification: false,
                                friend_request: false, interest_received: false,
                                viewed_profile: false, off_all_notification: true)
      else
        noti_params = notification_params
        noti_params[:off_all_notification] = false
        @account_setting.update(noti_params)
      end

      if @account_setting.errors.blank?
        serializer = BxBlockPrivacySettings::NotificationSettingSerializer.new(@account_setting)
        render json: serializer.serializable_hash,
               status: :ok
      else
        render json: { errors: @account_setting.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def activity_params
      params.require(:data)[:attributes].permit \
        :latest_activity,
        :older_activity
    end

    def notification_params
      params.require(:data)[:attributes].permit \
        :in_app_notification,
        :chat_notification,
        :friend_request,
        :interest_received,
        :viewed_profile,
        :off_all_notification
    end

    def load_account_setting
      @account_setting = BxBlockPrivacySettings::PrivacySetting.find_by_account_id(current_user.id)

      if @account_setting.nil?
        render json: {
          message: 'Setting not found'
        }, status: :not_found
      end
    end
  end
end

module BxBlockNotifications
  class NotificationsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :current_user

    def show
      @notifications = Notification.where('account_id = ?', current_user.id).order(created_at: :desc).page(params[:page]).per(params[:per])
      if @notifications.present?
        render json: NotificationSerializer.new(@notifications, meta: 
          pagenation_data(@notifications)).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'No notification found.'},]}, status: :ok
      end
    end

    def index
      @notifications = Notification.where('account_id = ?', current_user.id).order(created_at: :desc).page(params[:page]).per(params[:per])
      if @notifications.present?
        render json: NotificationSerializer.new(@notifications, meta: 
          pagenation_data(@notifications)).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'No notification found.'},]}, status: :ok
      end
    end

    def create
      @notification = Notification.new(notification_paramas)
      if @notification.save
        render json: NotificationSerializer.new(@notification, meta: {
            message: "Notification created."}).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@notification.errors)},
               status: :unprocessable_entity
      end
    end

    def update
      @notifications = Notification.where('account_id = ?', current_user.id)
      if @notifications.update_all(is_read: true, read_at: DateTime.now)
        render json: NotificationSerializer.new(@notification, meta: {
          message: "Notification marked as read."}).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(@notification.errors)},
               status: :unprocessable_entity
      end
    end

    def destroy
      @notification = Notification.find(params[:id])
      if @notification.destroy
        render json: {message: "Deleted."}, status: :ok
      else
        render json: {errors: format_activerecord_errors(@notification.errors)},
               status: :unprocessable_entity
      end
    end

    private

    def pagenation_data data
	    notificable = Kaminari.paginate_array(data)
			{
				page: notificable.page(params[:page]).current_page,
				totalPage: notificable.page(params[:page]).total_pages,
        unread: data.where(is_read: false).count
			}
		end


    def notification_paramas
      params.require(:notification).permit(
        :headings, :contents, :app_url, :account_id
      ).merge(created_by: @current_user.id)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end

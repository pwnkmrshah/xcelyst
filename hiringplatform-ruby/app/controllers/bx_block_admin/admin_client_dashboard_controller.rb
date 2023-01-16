module BxBlockAdmin 
    class AdminClientDashboardController < ApplicationController
        before_action :admin_user


        # created by akash deep
        # fetch all the clients and show them on admin panel where admin can manage client and candidate processes.
        def index
            client_records = AccountBlock::Account.clients
            if client_records.present?
                records = Kaminari.paginate_array(client_records).page(params[:page]).per(20)
                render json: AccountBlock::EmailAccountSerializer.new(records, meta: pagination_data(records)).serializable_hash, status: 200
            else
                render json: { message: "No Client present." }, status: 200
            end
        end

        # created by akash deep
        # search the client on admin panel by his/her first or last name.
        def client_search
            search_records = AccountBlock::Account.clients.where("email ILIKE :q OR first_name ILIKE :q OR last_name ILIKE :q", q: "%#{params[:query].downcase}%")
            if search_records.present?
                render json: AccountBlock::EmailAccountSerializer.new(search_records).serializable_hash, status: 200
            else
                render json: { message: "No record found." }, status: 200
            end
        end

        private

        def admin_user
            token = request.headers[:token] || params[:token]
            @token = BuilderJsonWebToken::JsonWebToken.decode(token)
            @admin = AdminUser.find(@token.admin_id)
            unless @admin.present?
                return render json: { message: "Only Admin is authorize for this request." }
            end
        end

        # created by akash deep
        # set the pagination data format.
        def pagination_data data
            {
                total_record: data.count,
                limit_value: data.page(params[:page]).limit_value,
                total_pages:  data.page(params[:page]).total_pages,
                current_page: data.page(params[:page]).current_page,
                next_page: data.page(params[:page]).next_page,
                prev_page: data.page(params[:page]).prev_page,
                is_first_page: data.page(params[:page]).first_page?,
                is_last_page: data.page(params[:page]).last_page?,
                is_out_of_range: data.page(params[:page]).out_of_range?
            }
        end
      
    end
end
ActiveAdmin.register BxBlockProfile::TestScoreAndCourse, as: 'TestDome' do

    permit_params :title, :test_id, :test_url
    actions :all, :except => [:new]

    index do
      render partial: 'admin/batch_action'
      selectable_column
      id_column
      column :title
      column :test_id
      actions
    end
    
    filter :title

    show do
      attributes_table do 
        row :title
        row :test_id
        row :test_url
      end
      uri = URI.parse("https://testdome.com/api/v1/token")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
       
      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' # use your service key here
      }

      data = {
        grant_type: "password",
        username: "namita.akhauri@xcelyst.com",
        password: "BqeGCfKp0NiyblzyCXyx"
      }.to_json
       
      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      # req.body = data
      req.set_form_data( grant_type: "password", username: "namita.akhauri@xcelyst.com", password: "BqeGCfKp0NiyblzyCXyx")
      res = https.request(req)
      responsee = JSON.parse(res.body)
      auth = responsee['access_token']
      #=========================================================================================================================#
      ## FETCH ALL candidates
      #=========================================================================================================================#
      uri2 = URI.parse("https://testdome.com/api/v1/candidates")
      https = Net::HTTP.new(uri2.host,uri2.port)
      https.use_ssl = true
       
      headers2 = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + auth
      }

      request = Net::HTTP::Get.new(uri2.path, initheader = headers2)
      request.set_form_data( testId: resource.test_id)
      res2 = https.request(request)
      result = JSON.parse(res2.body)
      table_for result do
        column "Full Name" do |res|
          res["fullName"]
        end
        column "Email" do |res|
          res["email"]
        end
        column "Score" do |res|
          res["testScore"]
        end
        column "Status" do |res|
          res["status"]
        end
        column "Report Url" do |res|
          link_to("View candidate Report", res["reportUrl"], target: :_blank) if  res["reportUrl"].present?
        end
      end
      # result.each do |user|
      #   user_email =  user["email"]
      #   acc = AccountBlock::Account.find_by_email(user_email)
      #   test_data = BxBlockProfile::TestScoreAndCourse.find_by(test_id: resource.test_id)
      #   # save candidate data
      #   if acc.present? && test_data.present?
      #     # Test and Acccount data
      #     BxBlockProfile::TestAccount.find_or_create_by(test_score_and_course_id: test_data.id, account_id:acc.id)
      #   end  
      #   # test_data.account_id = acc.id if acc.present? && test_data.present?
      #   # test_data.save!
      #   # puts "======================"
      #   # puts test_data
      # end  
    end

    form do |f|
    f.inputs do
      f.input :title,input_html: { readonly: true, disabled: true }
      f.input :test_id,input_html: { readonly: true, disabled: true }
      f.input :test_url
      f.input :role_ids, as: :select, collection: BxBlockRolesPermissions::Role.all, input_html: { multiple: true }
    end
     uri = URI.parse("https://testdome.com/api/v1/token")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
       
      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' # use your service key here
      }

      data = {
        grant_type: "password",
        username: "namita.akhauri@xcelyst.com",
        password: "BqeGCfKp0NiyblzyCXyx"
      }.to_json
       
      req = Net::HTTP::Post.new(uri.path, initheader = headers)
      # req.body = data
      req.set_form_data( grant_type: "password", username: "namita.akhauri@xcelyst.com", password: "BqeGCfKp0NiyblzyCXyx")
      res = https.request(req)
      responsee = JSON.parse(res.body)
      auth = responsee['access_token']

      #=========================================================================================================================#
      ## FETCH ALL TESTS
      uri2 = URI.parse("https://testdome.com/api/v1/candidates")
      https = Net::HTTP.new(uri2.host,uri2.port)
      https.use_ssl = true
       
      headers2 = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer ' + auth
      }

      request = Net::HTTP::Get.new(uri2.path, initheader = headers2)
      request.set_form_data( testId: resource.test_id)
      res2 = https.request(request)
      result = JSON.parse(res2.body)
      table_for result do
        column "Full Name" do |res|
          res["fullName"]
        end
        column "Email" do |res|
          res["email"]
        end
        column "Score" do |res|
          res["testScore"]
        end
        column "Status" do |res|
          res["status"]
        end
        column "Report Url" do |res|
          link_to("View candidate Report", res["reportUrl"], target: :_blank) if  res["reportUrl"].present?
        end
      end
    f.actions
  end
  end
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_07_094441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_categories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.string "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "platform"
    t.string "user_type"
    t.integer "app_language_id"
    t.datetime "last_visit_at"
    t.boolean "is_blacklisted", default: false
    t.string "stripe_id"
    t.string "stripe_subscription_id"
    t.datetime "stripe_subscription_date"
    t.integer "role_id"
    t.string "full_name"
    t.integer "gender"
    t.date "date_of_birth"
    t.integer "age"
    t.boolean "is_paid", default: false
    t.string "current_city"
    t.string "user_role"
    t.integer "otp"
    t.datetime "otp_valid_till"
    t.string "reset_password_token"
    t.string "cover_letter_url"
    t.string "resume_url"
    t.string "photo"
    t.string "document_id"
    t.boolean "is_converted_account", default: false
  end

  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.date "achievement_date"
    t.text "detail"
    t.string "url"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default_image", default: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.integer "addressble_id"
    t.string "addressble_type"
    t.integer "address_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "otp"
    t.datetime "otp_valid_till"
    t.boolean "logged_in", default: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "advertisements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "plan_id"
    t.string "duration"
    t.integer "advertisement_for"
    t.integer "status"
    t.integer "seller_account_id"
    t.datetime "start_at"
    t.datetime "expire_at"
  end

  create_table "applied_jobs", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "role_id"
    t.integer "company_page_id"
    t.string "applied_job_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "pending"
    t.boolean "accepted"
    t.bigint "shortlisting_candidate_id"
    t.float "final_score"
    t.string "final_feedback"
  end

  create_table "associated_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "associated_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "associateds", force: :cascade do |t|
    t.string "associated_with_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "audio_podcasts", force: :cascade do |t|
    t.string "heading"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "content_type_id", null: false
    t.string "image"
    t.string "audio_url"
    t.index ["content_type_id"], name: "index_audio_podcasts_on_content_type_id"
  end

  create_table "audios", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_audios_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_audios_on_attached_item_type"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "service_provider_id"
    t.string "start_time"
    t.string "end_time"
    t.string "unavailable_start_time"
    t.string "unavailable_end_time"
    t.string "availability_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "timeslots"
    t.integer "available_slots_count"
    t.index ["service_provider_id"], name: "index_availabilities_on_service_provider_id"
  end

  create_table "awards", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "issuer"
    t.datetime "issue_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "black_list_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_black_list_users_on_account_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bookmarks_on_account_id"
    t.index ["content_id"], name: "index_bookmarks_on_content_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "business_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "business_domain_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_domain_id"], name: "index_business_categories_on_business_domain_id"
  end

  create_table "business_domains", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "business_sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "business_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_category_id"], name: "index_business_sub_categories_on_business_category_id"
  end

  create_table "bx_block_aboutpage_about_pages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_appointment_management_booked_slots", force: :cascade do |t|
    t.bigint "order_id"
    t.string "start_time"
    t.string "end_time"
    t.bigint "service_provider_id"
    t.date "booking_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_custom_user_subs_subscriptions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.date "valid_up_to"
  end

  create_table "career_experience_employment_types", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "career_experience_industry", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "career_experience_system_experiences", force: :cascade do |t|
    t.integer "career_experience_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "system_experience_id"
    t.integer "profile_id"
  end

  create_table "career_experiences", force: :cascade do |t|
    t.string "job_title"
    t.date "start_date"
    t.date "end_date"
    t.string "company_name"
    t.text "description"
    t.string "add_key_achievements", default: [], array: true
    t.boolean "make_key_achievements_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "current_salary", default: "0.0"
    t.text "notice_period"
    t.date "notice_period_end_date"
    t.boolean "currently_working_here", default: false
  end

  create_table "careers", force: :cascade do |t|
    t.string "profession"
    t.boolean "is_current", default: false
    t.string "experience_from"
    t.string "experience_to"
    t.string "payscale"
    t.string "company_name"
    t.string "accomplishment", array: true
    t.integer "sector"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_reviews", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_reviews_on_catalogue_id"
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_color_id"
    t.bigint "catalogue_variant_size_id"
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["catalogue_variant_color_id"], name: "index_catalogue_variants_on_catalogue_variant_color_id"
    t.index ["catalogue_variant_size_id"], name: "index_catalogue_variants_on_catalogue_variant_size_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["tag_id"], name: "index_catalogues_tags_on_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_user_id"
    t.integer "rank"
    t.string "light_icon"
    t.string "light_icon_active"
    t.string "light_icon_inactive"
    t.string "dark_icon"
    t.string "dark_icon_active"
    t.string "dark_icon_inactive"
    t.integer "identifier"
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "company_page_company_sizes", force: :cascade do |t|
    t.integer "company_page_id"
    t.integer "company_size_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_page_company_types", force: :cascade do |t|
    t.integer "company_page_id"
    t.integer "company_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_page_industries", force: :cascade do |t|
    t.integer "company_page_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_pages", force: :cascade do |t|
    t.string "company_name"
    t.string "website"
    t.string "company_tagline"
    t.string "country"
    t.string "address"
    t.string "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "company_description"
    t.string "headquarters"
    t.date "founded"
    t.text "specialities"
  end

  create_table "company_sizes", force: :cascade do |t|
    t.string "size_of_company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_types", force: :cascade do |t|
    t.string "type_of_company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_contacts_on_account_id"
  end

  create_table "content_texts", force: :cascade do |t|
    t.string "headline"
    t.text "content"
    t.string "hyperlink"
    t.string "affiliation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "content_type_id", null: false
    t.string "images", default: [], array: true
    t.text "synopsis"
    t.index ["content_type_id"], name: "index_content_texts_on_content_type_id"
  end

  create_table "content_types", force: :cascade do |t|
    t.string "name"
    t.integer "type"
    t.integer "identifier"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "content_videos", force: :cascade do |t|
    t.string "separate_section"
    t.string "headline"
    t.string "description"
    t.string "thumbnails"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "content_type_id", null: false
    t.string "video_url"
    t.string "image"
    t.boolean "active", default: false
    t.index ["content_type_id"], name: "index_content_videos_on_content_type_id"
  end

  create_table "contents", force: :cascade do |t|
    t.integer "sub_category_id"
    t.integer "category_id"
    t.integer "content_type_id"
    t.integer "language_id"
    t.integer "status"
    t.datetime "publish_date"
    t.boolean "archived", default: false
    t.boolean "feature_article"
    t.boolean "feature_video"
    t.string "searchable_text"
    t.integer "review_status"
    t.string "feedback"
    t.integer "admin_user_id"
    t.bigint "view_count", default: 0
    t.string "contentable_type"
    t.bigint "contentable_id"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_contents_on_author_id"
    t.index ["contentable_type", "contentable_id"], name: "index_contents_on_contentable_type_and_contentable_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "conversation_sid", null: false
    t.string "unique_name", null: false
    t.string "friendly_name"
    t.string "url"
    t.bigint "client_id", null: false
    t.bigint "candidate_id", null: false
    t.string "client_sid", null: false
    t.string "candidate_sid", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.string "duration"
    t.string "year"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cta", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.bigint "category_id"
    t.string "long_background_image"
    t.string "square_background_image"
    t.string "button_text"
    t.string "redirect_url"
    t.integer "text_alignment"
    t.integer "button_alignment"
    t.boolean "is_square_cta"
    t.boolean "is_long_rectangle_cta"
    t.boolean "is_text_cta"
    t.boolean "is_image_cta"
    t.boolean "has_button"
    t.boolean "visible_on_home_page"
    t.boolean "visible_on_details_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_cta_on_category_id"
  end

  create_table "current_annual_salaries", force: :cascade do |t|
    t.string "current_annual_salary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "current_annual_salary_current_status", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "current_annual_salary_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status", force: :cascade do |t|
    t.string "most_recent_job_title"
    t.string "company_name"
    t.text "notice_period"
    t.date "end_date"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status_employment_types", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status_industries", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "degree_educational_qualifications", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "degree_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "degrees", force: :cascade do |t|
    t.string "degree_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "domain_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "domain_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_id"], name: "index_domain_categories_on_domain_id"
  end

  create_table "domain_sub_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "domain_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_category_id"], name: "index_domain_sub_categories_on_domain_category_id"
  end

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "download_limits", force: :cascade do |t|
    t.integer "no_of_downloads"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "download_pdfs", force: :cascade do |t|
    t.bigint "temporary_user_database_id", null: false
    t.string "ip_address"
    t.string "mac_address"
    t.datetime "download_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["temporary_user_database_id"], name: "index_download_pdfs_on_temporary_user_database_id"
  end

  create_table "educational_qualification_field_study", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "field_study_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "educational_qualifications", force: :cascade do |t|
    t.string "school_name"
    t.date "start_date"
    t.date "end_date"
    t.string "grades"
    t.text "description"
    t.boolean "make_grades_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string "qualification"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "year_from"
    t.string "year_to"
    t.text "description"
  end

  create_table "email_notifications", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.string "send_to_email"
    t.datetime "sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notification_id"], name: "index_email_notifications_on_notification_id"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employment_types", force: :cascade do |t|
    t.string "employment_type_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "epubs", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "content_type_id", null: false
    t.string "pdfs", default: [], array: true
    t.index ["content_type_id"], name: "index_epubs_on_content_type_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.date "to"
    t.date "from"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favourite_converstions", force: :cascade do |t|
    t.string "sid"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_favourite_converstions_on_account_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "favourite_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "favouriteable_id"
    t.string "favouriteable_type"
  end

  create_table "feedback_interviews", force: :cascade do |t|
    t.string "name"
  end

  create_table "feedback_parameter_lists", force: :cascade do |t|
    t.string "name"
  end

  create_table "field_study", force: :cascade do |t|
    t.string "field_of_study"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "company_page_id"
    t.bigint "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_page_id"], name: "index_follows_on_company_page_id"
    t.index ["profile_id"], name: "index_follows_on_profile_id"
  end

  create_table "global_settings", force: :cascade do |t|
    t.string "notice_period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hobbies_and_interests", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "home_pages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
    t.boolean "active", default: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_images_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_images_on_attached_item_type"
  end

  create_table "industries", force: :cascade do |t|
    t.string "industry_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "interview_feedbacks", force: :cascade do |t|
    t.bigint "feedback_parameter_lists_id", null: false
    t.float "rating"
    t.text "comments"
    t.bigint "applied_jobs_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["applied_jobs_id"], name: "index_interview_feedbacks_on_applied_jobs_id"
    t.index ["feedback_parameter_lists_id"], name: "index_interview_feedbacks_on_feedback_parameter_lists_id"
  end

  create_table "interview_schedules", force: :cascade do |t|
    t.string "event_title"
    t.string "event_description"
    t.string "joinee_name"
    t.boolean "reminder", default: false
    t.integer "applied_job_id"
    t.integer "profile_id"
    t.integer "invitation_type"
    t.datetime "schedule_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
  end

  create_table "interviewers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_descriptions", force: :cascade do |t|
    t.string "job_title"
    t.string "role_title"
    t.bigint "preferred_overall_experience_id", null: false
    t.string "minimum_salary"
    t.string "location"
    t.text "company_description"
    t.text "job_responsibility"
    t.bigint "role_id", null: false
    t.string "currency"
    t.jsonb "parsed_jd"
    t.string "jd_type"
    t.string "parsed_jd_transaction_id"
    t.string "degree"
    t.string "fieldOfStudy"
    t.string "others_skills", default: [], array: true
    t.string "sovren_ui_url"
    t.string "document_id"
    t.index ["preferred_overall_experience_id"], name: "index_job_descriptions_on_preferred_overall_experience_id"
    t.index ["role_id"], name: "index_job_descriptions_on_role_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "job_title"
    t.boolean "remote_job", default: true
    t.string "location"
    t.integer "employment_type_id"
    t.integer "total_inteview_rounds"
    t.integer "skill_id", default: [], array: true
    t.integer "question_answer_id"
    t.text "job_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
    t.integer "company_page_id"
    t.string "other_skills", default: [], array: true
    t.decimal "salary", default: "0.0"
    t.string "seniority_level"
    t.string "job_function"
    t.string "industries"
  end

  create_table "jobs_suggestions", force: :cascade do |t|
    t.string "suggestion"
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.string "proficiency"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "like_by_id"
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
  end

  create_table "live_streams", force: :cascade do |t|
    t.string "headline"
    t.string "description"
    t.string "comment_section"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "location_addresses", force: :cascade do |t|
    t.string "country"
    t.text "address"
    t.string "email"
    t.string "phone"
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.integer "van_id"
    t.text "address"
    t.string "locationable_type", null: false
    t.bigint "locationable_id", null: false
    t.index ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_managers_on_account_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "imageable_type"
    t.string "imageable_id"
    t.string "file_name"
    t.string "file_size"
    t.string "presigned_url"
    t.integer "status"
    t.string "category"
  end

  create_table "members_bios", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "position"
    t.bigint "content_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
    t.string "facebook_link"
    t.string "linkedin_link"
    t.string "twitter_link"
    t.integer "order"
    t.index ["content_type_id"], name: "index_members_bios_on_content_type_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "created_by"
    t.string "headings"
    t.string "contents"
    t.string "app_url"
    t.boolean "is_read", default: false
    t.datetime "read_at"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notificable_type"
    t.bigint "notificable_id"
    t.string "notification_type"
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["notificable_type", "notificable_id"], name: "index_notifications_on_notificable_type_and_notificable_id"
  end

  create_table "payment_admins", force: :cascade do |t|
    t.string "transaction_id"
    t.bigint "account_id", null: false
    t.bigint "current_user_id"
    t.string "payment_status"
    t.integer "payment_method"
    t.decimal "user_amount", precision: 10, scale: 2
    t.decimal "post_creator_amount", precision: 10, scale: 2
    t.decimal "third_party_amount", precision: 10, scale: 2
    t.decimal "admin_amount", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_payment_admins_on_account_id"
    t.index ["current_user_id"], name: "index_payment_admins_on_current_user_id"
  end

  create_table "pdfs", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "pdf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_pdfs_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_pdfs_on_attached_item_type"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.float "price"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
    t.string "location"
    t.integer "account_id"
    t.index ["category_id"], name: "index_posts_on_category_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "seeking"
    t.string "discover_people", array: true
    t.text "location"
    t.integer "distance"
    t.integer "height_type"
    t.integer "body_type"
    t.integer "religion"
    t.integer "smoking"
    t.integer "drinking"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "friend", default: false
    t.boolean "business", default: false
    t.boolean "match_making", default: false
    t.boolean "travel_partner", default: false
    t.boolean "cross_path", default: false
    t.integer "age_range_start"
    t.integer "age_range_end"
    t.string "height_range_start"
    t.string "height_range_end"
    t.integer "account_id"
  end

  create_table "preferred_overall_experiences", force: :cascade do |t|
    t.string "experiences_year"
    t.string "level"
    t.string "grade"
    t.integer "minimum_experience"
    t.integer "maximum_experience"
  end

  create_table "preferred_roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "preferred_skill_levels", force: :cascade do |t|
    t.string "experiences_year"
    t.string "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "preferred_skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_preferred_skills_on_name"
  end

  create_table "privacy_policies", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "privacy_policy_informations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "privacy_settings", force: :cascade do |t|
    t.integer "account_id"
    t.boolean "latest_activity", default: true
    t.boolean "older_activity", default: false
    t.boolean "in_app_notification", default: true
    t.boolean "chat_notification", default: true
    t.boolean "friend_request", default: true
    t.boolean "interest_received", default: true
    t.boolean "viewed_profile", default: true
    t.boolean "off_all_notification", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profile_bios", force: :cascade do |t|
    t.integer "account_id"
    t.string "height"
    t.string "weight"
    t.integer "height_type"
    t.integer "weight_type"
    t.integer "body_type"
    t.integer "mother_tougue"
    t.integer "religion"
    t.integer "zodiac"
    t.integer "marital_status"
    t.string "languages", array: true
    t.text "about_me"
    t.string "personality", array: true
    t.string "interests", array: true
    t.integer "smoking"
    t.integer "drinking"
    t.integer "looking_for"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "about_business"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "country"
    t.string "address"
    t.string "postal_code"
    t.integer "account_id"
    t.string "photo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_role"
    t.string "city"
    t.text "about_business"
    t.string "current_compensation"
    t.string "expected_compensation"
    t.text "notice_period"
    t.string "preferred_role_ids", default: [], array: true
    t.string "location_preference", default: [], array: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.date "start_date"
    t.date "end_date"
    t.string "add_members"
    t.string "url"
    t.text "description"
    t.boolean "make_projects_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "publication_patents", force: :cascade do |t|
    t.string "title"
    t.string "publication"
    t.string "authors"
    t.string "url"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "push_notifications", force: :cascade do |t|
    t.bigint "account_id"
    t.string "push_notificable_type", null: false
    t.bigint "push_notificable_id", null: false
    t.string "remarks"
    t.boolean "is_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notify_type"
    t.index ["account_id"], name: "index_push_notifications_on_account_id"
    t.index ["push_notificable_type", "push_notificable_id"], name: "index_push_notification_type_and_id"
  end

  create_table "question_answers", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "request_demos", force: :cascade do |t|
    t.string "phone_no"
    t.string "email"
    t.string "company_name"
    t.text "contact_information"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "account_id"
    t.integer "sender_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reschedule_interviews", force: :cascade do |t|
    t.integer "interview_schedule_id"
    t.datetime "reschedule_date"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.integer "position"
    t.text "managers", default: [], array: true
    t.boolean "is_closed", default: false
    t.index ["account_id"], name: "index_roles_on_account_id"
  end

  create_table "save_jobs", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "profile_id", null: false
    t.boolean "favourite"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_save_jobs_on_profile_id"
    t.index ["role_id"], name: "index_save_jobs_on_role_id"
  end

  create_table "schedule_interviews", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "job_description_id", null: false
    t.bigint "role_id", null: false
    t.datetime "first_slot"
    t.datetime "second_slot"
    t.datetime "third_slot"
    t.boolean "require_admin_support", default: false
    t.string "preferred_slot"
    t.boolean "is_accepted_by_candidate", default: false
    t.boolean "request_alt_slots", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id", null: false
    t.string "interview_type"
    t.string "feedback"
    t.bigint "interviewer_id"
    t.float "rating"
    t.string "time_zone"
    t.index ["account_id"], name: "index_schedule_interviews_on_account_id"
    t.index ["interviewer_id"], name: "index_schedule_interviews_on_interviewer_id"
    t.index ["job_description_id"], name: "index_schedule_interviews_on_job_description_id"
    t.index ["role_id"], name: "index_schedule_interviews_on_role_id"
  end

  create_table "seller_accounts", force: :cascade do |t|
    t.string "firm_name"
    t.string "full_phone_number"
    t.text "location"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "gstin_number"
    t.boolean "wholesaler"
    t.boolean "retailer"
    t.boolean "manufacturer"
    t.boolean "hallmarking_center"
    t.float "buy_gold"
    t.float "buy_silver"
    t.float "sell_gold"
    t.float "sell_silver"
    t.string "deal_in", default: [], array: true
    t.text "about_us"
    t.boolean "activated", default: false, null: false
    t.bigint "account_id", null: false
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_seller_accounts_on_account_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.string "name"
  end

  create_table "shortlisting_candidates", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "job_description_id", null: false
    t.bigint "candidate_id", null: false
    t.boolean "is_shortlisted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "shortlisted_by_admin"
    t.boolean "is_applied_by_candidate"
    t.integer "sovren_score"
    t.index ["candidate_id"], name: "index_shortlisting_candidates_on_candidate_id"
    t.index ["client_id"], name: "index_shortlisting_candidates_on_client_id"
    t.index ["job_description_id"], name: "index_shortlisting_candidates_on_job_description_id"
  end

  create_table "skill_matrices", force: :cascade do |t|
    t.bigint "job_description_id"
    t.bigint "domain_sub_category_id"
    t.integer "preferred_overall_experience_ids", default: [], array: true
    t.integer "preferred_skill_level_ids", array: true
    t.index ["domain_sub_category_id"], name: "index_skill_matrices_on_domain_sub_category_id"
    t.index ["job_description_id"], name: "index_skill_matrices_on_job_description_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "skill_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "slot", force: :cascade do |t|
    t.bigint "interview_schedule_id", null: false
    t.datetime "schedule_date"
    t.index ["interview_schedule_id"], name: "index_slot_on_interview_schedule_id"
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "social_media_links", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.integer "rank"
  end

  create_table "system_experiences", force: :cascade do |t|
    t.string "system_experience"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "taggings_count", default: 0
  end

  create_table "temporary_accounts", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.jsonb "parsed_resume"
    t.string "document_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_no"
    t.integer "sovren_score"
    t.boolean "is_permanent", default: false
  end

  create_table "temporary_user_databases", force: :cascade do |t|
    t.string "full_name"
    t.string "title"
    t.string "zipcode"
    t.string "city"
    t.string "status"
    t.boolean "ready_to_move"
    t.string "name"
    t.string "location", default: [], array: true
    t.string "experience"
    t.string "company"
    t.string "previous_work", default: [], array: true
    t.string "skills", default: [], array: true
    t.string "degree"
    t.string "job_projects"
    t.string "lead_lists"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "photo_url"
    t.jsonb "contacts"
    t.jsonb "social_url"
    t.jsonb "position"
    t.text "summary"
    t.integer "experience_month"
    t.string "uid"
  end

  create_table "temporary_user_profiles", force: :cascade do |t|
    t.bigint "temporary_user_database_id", null: false
    t.text "skills", default: [], array: true
    t.string "head_line"
    t.text "courses", default: [], array: true
    t.text "certificates", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "work_experience"
    t.jsonb "languages"
    t.jsonb "education"
    t.jsonb "organizations"
    t.index ["temporary_user_database_id"], name: "index_temporary_user_profiles_on_temporary_user_database_id"
  end

  create_table "term_conditions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "test_accounts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "test_score_and_course_id", null: false
    t.index ["account_id"], name: "index_test_accounts_on_account_id"
    t.index ["test_score_and_course_id"], name: "index_test_accounts_on_test_score_and_course_id"
  end

  create_table "test_score_and_courses", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "score"
    t.datetime "test_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "test_id"
    t.string "test_url"
    t.string "status"
    t.string "invitation_end_date"
    t.integer "role_ids", default: [], array: true
  end

  create_table "tests", force: :cascade do |t|
    t.text "description"
    t.string "headline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "order_id"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.integer "account_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_categories_on_account_id"
    t.index ["category_id"], name: "index_user_categories_on_category_id"
  end

  create_table "user_preferred_skills", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "preferred_skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_preferred_skills_on_account_id"
    t.index ["preferred_skill_id"], name: "index_user_preferred_skills_on_preferred_skill_id"
  end

  create_table "user_resumes", force: :cascade do |t|
    t.string "resume_id", null: false
    t.bigint "account_id", null: false
    t.text "resume_file"
    t.jsonb "parsed_resume"
    t.string "transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "index_id"
    t.string "document_id"
    t.integer "sovren_score"
    t.index ["account_id"], name: "index_user_resumes_on_account_id"
    t.index ["resume_id"], name: "index_user_resumes_on_resume_id"
  end

  create_table "user_sub_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_sub_categories_on_account_id"
    t.index ["sub_category_id"], name: "index_user_sub_categories_on_sub_category_id"
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "subscription_id"
  end

  create_table "van_members", force: :cascade do |t|
    t.integer "account_id"
    t.integer "van_id"
  end

  create_table "vans", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.boolean "is_offline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "videos", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_videos_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_videos_on_attached_item_type"
  end

  create_table "view_profiles", force: :cascade do |t|
    t.integer "profile_bio_id"
    t.integer "view_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
  end

  create_table "watched_records", force: :cascade do |t|
    t.bigint "temporary_user_database_id", null: false
    t.string "ip_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["temporary_user_database_id"], name: "index_watched_records_on_temporary_user_database_id"
  end

  create_table "whatsapp_chats", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.string "user_type", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_whatsapp_chats_on_admin_user_id"
    t.index ["user_type", "user_id"], name: "index_whatsapp_chats_on_user_type_and_user_id"
  end

  create_table "whatsapp_messages", force: :cascade do |t|
    t.bigint "whatsapp_chat_id", null: false
    t.text "message"
    t.string "sender_type", null: false
    t.bigint "sender_id", null: false
    t.string "receiver_type", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_type", "receiver_id"], name: "index_whatsapp_messages_on_receiver_type_and_receiver_id"
    t.index ["sender_type", "sender_id"], name: "index_whatsapp_messages_on_sender_type_and_sender_id"
    t.index ["whatsapp_chat_id"], name: "index_whatsapp_messages_on_whatsapp_chat_id"
  end

  create_table "zoom_meetings", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.bigint "client_id", null: false
    t.datetime "schedule_date"
    t.string "starting_at"
    t.string "ending_at"
    t.jsonb "meeting_urls"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.bigint "zoom_id"
    t.bigint "schedule_interview_id", null: false
    t.integer "feedback_nofi_status"
    t.index ["schedule_interview_id"], name: "index_zoom_meetings_on_schedule_interview_id"
  end

  create_table "zooms", force: :cascade do |t|
    t.string "zoom_user_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_podcasts", "content_types"
  add_foreign_key "black_list_users", "accounts"
  add_foreign_key "bookmarks", "accounts"
  add_foreign_key "bookmarks", "contents"
  add_foreign_key "business_categories", "business_domains"
  add_foreign_key "business_sub_categories", "business_categories"
  add_foreign_key "catalogue_reviews", "catalogues"
  add_foreign_key "catalogue_variants", "catalogue_variant_colors"
  add_foreign_key "catalogue_variants", "catalogue_variant_sizes"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "categories"
  add_foreign_key "catalogues", "sub_categories"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "catalogues_tags", "tags"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "content_texts", "content_types"
  add_foreign_key "content_videos", "content_types"
  add_foreign_key "contents", "authors"
  add_foreign_key "domain_categories", "domains"
  add_foreign_key "domain_sub_categories", "domain_categories"
  add_foreign_key "download_pdfs", "temporary_user_databases"
  add_foreign_key "email_notifications", "notifications"
  add_foreign_key "epubs", "content_types"
  add_foreign_key "favourite_converstions", "accounts"
  add_foreign_key "interview_feedbacks", "applied_jobs", column: "applied_jobs_id"
  add_foreign_key "interview_feedbacks", "feedback_parameter_lists", column: "feedback_parameter_lists_id"
  add_foreign_key "job_descriptions", "preferred_overall_experiences"
  add_foreign_key "job_descriptions", "roles"
  add_foreign_key "managers", "accounts"
  add_foreign_key "members_bios", "content_types"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "payment_admins", "accounts"
  add_foreign_key "payment_admins", "accounts", column: "current_user_id"
  add_foreign_key "posts", "categories"
  add_foreign_key "push_notifications", "accounts"
  add_foreign_key "roles", "accounts"
  add_foreign_key "save_jobs", "profiles"
  add_foreign_key "save_jobs", "roles"
  add_foreign_key "schedule_interviews", "accounts"
  add_foreign_key "schedule_interviews", "interviewers"
  add_foreign_key "schedule_interviews", "job_descriptions"
  add_foreign_key "schedule_interviews", "roles"
  add_foreign_key "seller_accounts", "accounts"
  add_foreign_key "shortlisting_candidates", "job_descriptions"
  add_foreign_key "slot", "interview_schedules"
  add_foreign_key "temporary_user_profiles", "temporary_user_databases"
  add_foreign_key "test_accounts", "accounts"
  add_foreign_key "test_accounts", "test_score_and_courses"
  add_foreign_key "user_categories", "accounts"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_preferred_skills", "accounts"
  add_foreign_key "user_preferred_skills", "preferred_skills"
  add_foreign_key "user_resumes", "accounts"
  add_foreign_key "user_sub_categories", "accounts"
  add_foreign_key "user_sub_categories", "sub_categories"
  add_foreign_key "watched_records", "temporary_user_databases"
  add_foreign_key "zoom_meetings", "schedule_interviews"
end

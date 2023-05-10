class Ability
  include CanCan::Ability

  PERMISSIONS = {
    'browse' => [:read],
    'browse_ai_matching' => [:read],
    'browse_candidate' => [:read],
    'browse_client' => [:read],
    'browse_test_account' => [:read],
    'browse_shortlist_candidate' => [:read],
    'add' => [:new],
    'add' => [:create],
    'new_client' => [:create],
    'edit' => [:update],
    'edit_candidate' => [:update],
    'edit_client' => [:update],
    'upload_resume_file' => [:upload_resume_file],
    'upload_json_file' => [:upload_json_file],
    'make_permanent_account' => [:make_permanent_account],
    'bulk_send_messages' => [:bulk_send_messages],
    'import_bulk_resume' => [:import_bulk_resume],
    'import_json' => [:import_json],
    'bulk_send_messages_to_account' => [:bulk_send_messages_to_account],
    'delete' => [:destroy],
    'delete_candidate' => [:destroy],
    'delete_client' => [:destroy],
    'delete_shortlist_candidate' => [:destroy]
  }

  def initialize(user)
    if user.email == 'admin@xcelyst.com'
      can :manage, [ActiveAdmin::Page, BxBlockAdminRolePermission::AdminRole, UserAdmin, BxBlockCfzoomintegration3::ZoomMeeting, BxBlockCfzoomintegration3::Zoom, BxBlockDatabase::DownloadLimit, AccountBlock::TemporaryAccount]
    else
      can :manage, [ActiveAdmin::Page]
    end
    user ||= User.new # guest user (not logged in)

    return unless user.admin_role.present?

    user.admin_role.admin_permissions.each do |permission|
      account_block = ["ai matching", "candidate", "client", "test accounts", "shortlist candidate"].include? permission.module_name.downcase
      if account_block
        module_name = 'account block'
      else
        module_name = permission.module_name.downcase
      end

      module_type = get_module_type(module_name)

      can_permission_for_module(permission.name, module_type) if module_type
    end
  end

  private

  def get_module_type(module_name)
    case module_name
      when 'about page'            then BxBlockAboutpage::AboutPage
      when 'address'               then BxBlockAddress::LocationAddress
      when 'blogs'                 then BxBlockContentManagement::ContentText
      when 'rejected candidate'    then BxBlockRolesPermissions::AppliedJob
      when 'category'              then BxBlockDomainCategory::DomainCategory
      when 'contact request'       then BxBlockContactUs::Contact
      when 'content type'          then BxBlockContentManagement::ContentType
      when 'content video'         then BxBlockContentManagement::ContentVideo
      when 'database user'         then BxBlockDatabase::TemporaryUserDatabase
      when 'domain'                then BxBlockDomain::Domain
      when 'feedback interview'    then BxBlockScheduling::FeedbackInterview
      when 'feedback parameter'    then BxBlockFeedback::FeedbackParameterList
      when 'home page'             then BxBlockContentManagement::HomePage
      when 'interviewer'           then BxBlockManager::Interviewer
      when 'job description'       then BxBlockJobDescription::JobDescription
      when 'hiring manager'        then BxBlockManager::Manager
      when 'member bio'            then BxBlockContentManagement::MemberBio
      when 'overall experiences'   then BxBlockPreferredOverallExperiences::PreferredOverallExperiences
      when 'skill level'           then BxBlockPreferredOverallExperiences::PreferredSkillLevel
      when 'privacy policy'        then BxBlockInformation::PrivacyPolicy
      when 'request demo'          then BxBlockRequestdemo::RequestDemo
      when 'final feedback'        then BxBlockRolesPermissions::Role
      when 'shortlisted candidate' then BxBlockShortlisting::ShortlistingCandidate
      when 'social media links'    then BxBlockContentManagement::SocialMediaLink
      when 'sub category'          then BxBlockDomainSubCategory::DomainSubCategory
      when 'temporary account'     then AccountBlock::TemporaryAccount
      when 'terms & condition'     then BxBlockInformation::TermCondition
      when 'account block'         then AccountBlock::Account
      # when 'downloadlimit'         then BxBlockDatabase::DownloadLimit
    else nil
    end
  end

  def can_permission_for_module(name, module_type)
    if module_type == AccountBlock::Account
      permissions = PERMISSIONS[name.downcase]
      can permissions.first, module_type, user_role: name.split('_').second if permissions
    else
      permissions = PERMISSIONS[name.downcase]
      can permissions.first, module_type if permissions
    end
  end
end

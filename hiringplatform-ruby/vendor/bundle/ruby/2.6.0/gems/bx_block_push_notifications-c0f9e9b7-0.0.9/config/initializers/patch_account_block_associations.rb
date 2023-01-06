Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockPushNotifications::PatchAccountBlockAssociations
  )
end

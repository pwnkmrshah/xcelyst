Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockContentManagement::PatchAccountBlockAssociations
  )
end

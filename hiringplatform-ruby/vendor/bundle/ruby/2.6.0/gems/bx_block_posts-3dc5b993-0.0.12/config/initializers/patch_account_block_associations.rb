Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockPosts::PatchAccountBlockAssociations
  )
end

Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockLike::PatchAccountBlockAssociations
  )
end

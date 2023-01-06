Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockLanguageOptions::PatchAccountBlockAssociations
  )
end

Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockPayments::PatchAccountTransactionsAssociations
  )
end

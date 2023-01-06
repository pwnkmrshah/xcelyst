# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  AccountBlock::Account.include(
    BxBlockProfile::PatchAccountBlock
  )
end

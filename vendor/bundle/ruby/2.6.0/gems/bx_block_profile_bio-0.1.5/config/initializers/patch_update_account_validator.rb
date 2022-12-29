# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  BxBlockProfile::UpdateAccountValidator.include(
    BxBlockProfileBio::PatchUpdateAccountValidator
  )
end

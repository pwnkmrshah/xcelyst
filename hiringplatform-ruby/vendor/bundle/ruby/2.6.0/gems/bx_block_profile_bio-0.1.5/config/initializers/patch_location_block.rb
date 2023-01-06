# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  BxBlockLocation::Location.include(
    BxBlockProfileBio::PatchLocationBlock
  )
end

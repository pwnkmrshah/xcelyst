Rails.application.reloader.to_prepare do
  BxBlockPosts::Post.include(
    BxBlockLike::PatchBxBlockPostsAssociations
  )
end

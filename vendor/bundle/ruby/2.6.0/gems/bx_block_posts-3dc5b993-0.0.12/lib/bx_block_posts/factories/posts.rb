# FactoryBot.define do
#   factory :post, class: 'BxBlockPosts::Post' do
#     post { 'Test Post' }
#     images do
#       io = StringIO.new(
#         Base64.decode64(
#           'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=='
#         )
#       )
#       [{
#         io: io,
#         content_type: 'image/jpeg',
#         filename: 'image.jpg'
#       }]
#     end
#     account
#   end
# end

FactoryBot.define do
  factory :post, class: 'BxBlockPosts::Post' do
    name { Faker::Name.name }
    description { 'Test post description' }
    body { 'Test post body' }
    category { BxBlockCategories::Category.create!(name: Faker::Name.name)  }
    images do
      io = StringIO.new(
        Base64.decode64(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=='
        )
      )
      [{
        io: io,
        content_type: 'image/jpeg',
        filename: 'image.jpg'
      }]
    end
  end
end

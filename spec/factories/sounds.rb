FactoryBot.define do
  factory :sound do
    sequence :name do |n|
      "sound-#{n}"
    end
    duration { 5 }
    # user_id User.create!(email: 'example2@example.com', password: 'password')
    sequence :file_url do |n|
      "data/sound#{n}.wav"
    end
  end
end
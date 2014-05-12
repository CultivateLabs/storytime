FactoryGirl.define do
  factory :media, class: Storytime::Media do
    user
    file { Rack::Test::UploadedFile.new(File.open('./spec/support/images/success-kid.jpg'), 'image/jpg') }
  end
end

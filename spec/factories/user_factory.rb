FactoryBot.define do
  sequence(:email) { |n| "test#{n}@test.com" }
  sequence(:last_name) { |n| "Test#{n}" }
  sequence(:name) { |n| "name#{n}" }
  factory :user do
    first_name { 'John' }
    last_name
    email
    password { '12345678' }
    admin { false }
  end
  factory :admin, parent: :user do
    first_name { 'Admin' }
    last_name
    email
    password { '1234567890' }
    admin { true }
  end
  factory :product do
    name
    description { 'a product' }
    colour { 'some colour' }
    price { '100' }
    image_url { 'https://picsum.photos/1000' }
  end
end

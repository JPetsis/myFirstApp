FactoryBot.define do
  factory :product do
    name
    description { 'a product' }
    colour { 'some colour' }
    price { 100 }
    image_url { 'https://picsum.photos/1000' }
  end
end

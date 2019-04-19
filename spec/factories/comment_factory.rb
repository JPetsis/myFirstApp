FactoryBot.define do

  factory :comment do
      user
      product
      body "body"
      rating 5
  end
end

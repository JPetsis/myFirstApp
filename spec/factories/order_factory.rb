FactoryBot.define do
  factory :order do
    user
    product
    total { '300' }
  end
end

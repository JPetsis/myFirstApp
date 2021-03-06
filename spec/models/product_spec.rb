require 'rails_helper'

describe Product do

  context 'when the product has comments' do
    # let(:product) { Product.create!(name: 'race bike', description: 'test', colour: 'orange', price: '100', image_url: 'product.image.url') }
    let(:product) { FactoryBot.create(:product) }
    # let(:user) { User.create!(email: 'test1@gmail.com', password: '1234567') }
    let(:user) { FactoryBot.create(:user) }
    before do
      product.comments.create!(rating: 1, user: user, body: 'Awful bike!')
      product.comments.create!(rating: 3, user: user, body: 'Ok bike!')
      product.comments.create!(rating: 5, user: user, body: 'Great bike!')
    end
    it 'returns the average rating of all comments' do
      expect(product.average_rating).to eq 3
    end
  end

  context "when a product does not have a name" do
    it "is not valid" do
      expect(Product.new(description: 'Nice bike', colour: 'red', price: '200', image_url: 'test_image.url')).not_to be_valid 
    end
  end
end

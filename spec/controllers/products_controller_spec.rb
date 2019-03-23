require 'rails_helper'

describe ProductsController, type: :controller do
  # let(:admin_test_user1) { User.create!(email: 'admin_user1@gmail.com', password: '1234567890', admin: true) }
  admin1 = FactoryBot.create(:admin)
  # let(:normal_test_user1) { User.create!(email: 'normal_user1@gmail.com', password: '1234567890', admin: false) }
  test_user1 = FactoryBot.create(:user)
  # let(:product3) { Product.create!(name: 'name_1', description: 'desc_1', colour: 'red', image_url: 'https://picsum.photos/1000', price: 100) }
  product1 = FactoryBot.create(:product)
  describe 'GET #edit' do

    context 'when a user is admin' do
      before do
        sign_in admin1
      end
      it 'has access to edit a product' do
        get :edit, params: { id: product1.id }
        expect(assigns(:product)).to eq product1
        expect(response).to render_template('edit')
      end 
    end

    context 'a user is not admin' do
      before do
        sign_in test_user1
      end
      it 'has not access to edit a product' do
        get :edit, params: { id: product1.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

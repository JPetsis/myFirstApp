require 'rails_helper'

describe OrdersController, type: :controller do
  # let(:test_user) { User.create!(email: 'user@gmail.com', password: '12345678') }
  test_user_order = FactoryBot.createJ(:user)
  # let(:test_user1) { User.create!(email: 'user1@gmail.com', password: '123456789') }
  test_user_order1 = FactoryBot.create(:user)
  # let(:product4) { Product.create!(name: 'name_2', description: 'desc_2', colour: 'red', image_url: 'https://picsum.photos/2000', price: 300) }
  product2 = FactoryBot.create(:product)
  let(:order1) { Order.create!(user_id: test_user_order.id, product_id: product2.id) }
  let(:order2) { Order.create!(user_id: test_user_order1.id, product_id: product2.id) }
  describe 'GET #show' do

    context 'when a user is logged in' do
      before do
        sign_in test_user_order
      end
      it 'try to access his order' do
        get :show, params: { id: order1.id }
        expect(assigns(:order)).to eq order1
        expect(response).to render_template('orders/show')
      end
      it 'try to access order that belongs to another user' do
        sign_in test_user_order1
        get :show, params: { id: order1.id }
        expect(response).to have_http_status(302)
        expect(assigns(:test_user_order1)).not_to eq test_user_order
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

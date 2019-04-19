require 'rails_helper'

describe ProductsController, type: :controller do
  # let(:admin_test_user1) { User.create!(email: 'admin_user1@gmail.com', password: '1234567890', admin: true) }
  let(:admin1) { FactoryBot.create(:admin) }
  # let(:normal_test_user1) { User.create!(email: 'normal_user1@gmail.com', password: '1234567890', admin: false) }
  let(:test_user1) { FactoryBot.create(:user) }
  # let(:product3) { Product.create!(name: 'name_1', description: 'desc_1', colour: 'red', image_url: 'https://picsum.photos/1000', price: 100) }
  let!(:product1) { FactoryBot.create(:product) }

  describe 'GET #index' do

    it 'renders the products/index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end

    it 'assigns @products' do
      get :index
      expect(assigns(:products)).to eq [product1]
    end
  end

  describe 'GET #show' do

    it 'loads correct product' do
      get :show, params: { id: product1.id }
      expect(assigns(:product)).to eq product1
    end

    it 'renders the products/show template' do
      get :show, params: { id: product1.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

  describe 'GET #new' do

    context 'when user is admin' do
      before do
        sign_in admin1
      end

      it 'renders the products/new template' do
        get :new
        expect(response).to be_ok
        expect(response).to render_template('new')
      end
    end

    context 'when user is not an admin' do
      before do
        sign_in test_user1
      end
      
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

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

  describe 'POST products#create' do

    context 'when user is admin' do
      before do
        sign_in admin1
      end

      context 'with valid attributes' do
        it 'should save the new product in the database' do
          expect {
            post :create, params: { product: { name:"Any Name", description:"any description", colour:"red", price:"100", image_url:"http://some_image.com" } }
          }.to change(Product, :count).by(1)
        end

        it 'should redirect to the product#show page' do
          post :create, params: { product: { name:"Any Name", description:"any description", colour:"red", price:"100", image_url:"http://some_image.com" } }
          expect(response).to redirect_to Product.last
        end
      end

      context 'with invalid attributes' do
        it 'should not save the new product in the database' do
          expect {
            post :create, params: { product: { description:"Any text" } }
          }.to_not change(Product, :count)
        end

        it 'should render product#new template' do
          post :create, params: { product: { description:"Any text" } }
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is logged in not admin' do
      before do
        sign_in test_user1
      end
      
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH/PUT products#update' do

    context 'when user is admin' do
      before do
        sign_in admin1
      end

      context 'with valid attributes' do
        it 'loads correct product' do
          put :update, params: { id: product1.id, product: { name:"Edited Name" } }
          expect(assigns(:product)).to eq Product.last
        end

        it "changes product's attributes" do
          put :update, params: { id: product1.id, product: { name:"Edited Name", description:"Edited" } }
          product1.reload
          expect(product1.description).to eq("Edited")
        end

        it 'redirects to products index page' do
          put :update, params: { id: product1.id, product: { name: "Edited Name" } }
          expect(response).to redirect_to Product.last
        end
      end

      context 'with invalid attributes' do
        it 'loads correct product' do
          put :update, params: { id: product1.id, product: { name: nil } }
          expect(assigns(:product)).to eq Product.last
        end

        it "does not change product's attributes" do
          put :update, params: { id: product1.id, product: { name: nil, description: "Edited" } }
          product1.reload
          expect(product1.description).to_not eq("Edited")
        end

        it 'renders again the products edit template' do
          put :update, params: { id: product1.id, product: { name: nil } }
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user is logged in and not admin' do
      before do
        sign_in test_user1
      end
      
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE products#destroy' do

    context 'when user is admin' do
      before do
        sign_in admin1
      end

      it 'loads correct product' do
        delete :destroy, params: { id: product1.id }
        expect(assigns(:product)).to eq product1
      end

      it 'deletes product from database' do
        expect {
          delete :destroy, params: { id: product1.id }
        }.to change(Product, :count).by(-1)
      end

      it 'redirects to products index page' do
        delete :destroy, params: { id: product1.id }
        expect(response).to redirect_to products_path
      end
    end

    context 'when user is logged in and not admin' do
      before do
        sign_in test_user1
      end
      
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root' do
        get :new
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

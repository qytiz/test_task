# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    it 'assigns @users and renders the index template' do
      get :index
      expect(assigns(:users)).to include(user)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns @user and renders the show template' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user and renders the new template' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: attributes_for(:user) } }
    let(:invalid_params) { { user: { name: '', email: '' } } }

    context 'when Users::Create succeeds' do
      it 'creates a user and redirects to index' do
        create_interactor = instance_double(Users::Create, valid?: true)
        allow(Users::Create).to receive(:run).and_return(create_interactor)

        post :create, params: valid_params

        expect(response).to redirect_to(users_path)
        expect(Users::Create).to have_received(:run).with(params: anything).once
      end
    end

    context 'when Users::Create fails' do
      it 'renders the new template with an error message' do
        create_interactor = instance_double(Users::Create, valid?: false,
                                                           errors: double(full_messages: ['Ошибка создания']))
        allow(Users::Create).to receive(:run).and_return(create_interactor)

        post :create, params: invalid_params

        expect(response).to render_template(:new)
        expect(flash[:error]).to eq('Ошибка создания')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user and redirects to index' do
      expect do
        delete :destroy, params: { id: user.id }
      end.to change(User, :count).by(-1)

      expect(response).to redirect_to(users_path)
    end
  end
end

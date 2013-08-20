require 'spec_helper'

describe SessionsController do

  describe '#new' do
    
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end
    
    it 'redirects to the root url if the user is already logged in' do
      login_user(create(:user))
      get :new
      expect(response).to redirect_to(root_url)
    end

    it 'shows a warning message' do
      login_user(create(:user))
      get :new
      expect(flash[:notice]).to eq(I18n.t("auth.already_logged_message", logout_link: logout_path))
    end

  end

  describe '#create' do

    context 'when passing valid data' do

      let!(:user) { create(:user, email: "some@email.com", password: "12345", password_confirmation: "12345") }

      it 'logs in the user' do
        post :create, email: "some@email.com", password: "12345"
        expect(session[:user_id]).to eq(user.id)
      end

      it 'shows a welcome message' do
        post :create, email: "some@email.com", password: "12345"
        expect(flash[:notice]).to eq(I18n.t("auth.welcome_message", user: user.email))
      end

      context 'and remember me is on' do

        it 'remembers the user'

      end

    end

    context 'when passing invalid data' do
      render_views

      it 'renders the new template' do
        post :create, email: "some@email.com", password: "1234"
        expect(response).to render_template :new
      end

      it 'shows an error message to the user' do
        post :create, email: "some@email.com", password: "1234"
        expect(response.body).to include(I18n.t("auth.log_in_error_message"))
      end

    end

  end

end

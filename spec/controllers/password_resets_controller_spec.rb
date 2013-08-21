require 'spec_helper'

describe PasswordResetsController do
  render_views

  describe '#new' do

    it 'renders http success' do
      get :new
      expect(response).to be_success
    end

  end

  describe '#create' do

    let(:user) { create(:user) }

    context 'when sending a valid user email' do

      it 'delivers an email to that email' do
        expect {
          post :create, email: user.email
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end

      it 'redirects the user to the root url' do
        post :create, email: user.email
        expect(response).to redirect_to(root_url)
      end

    end

    context 'whn sending an invalid email' do

      it 'renders the new template' do
        post :create, email: "somethingnotanemail"
        expect(response).to render_template :new
      end

      it 'shows an error' do
        email = "somethingnotanemail"
        post :create, email: email
        expect(response.body).to include(I18n.t("auth.password_reset.user_not_found", email: email))
      end

    end

  end

  describe '#update' do

    let(:user) { create(:user, reset_password_token: "token") }

    context 'when submitting valid data' do

      before :each do
        User.should_receive(:load_from_reset_password_token).with(user.reset_password_token).and_return(user)
      end

      it 'updates user password' do
        expect {
          put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: "validpass"}
        }.to change(user, :crypted_password)
      end

      it 'redirects the user to the root url' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: "validpass"}
        expect(response).to redirect_to(root_url)
      end

    end

    context 'when not submitting a token' do

      it 'redirects the user to the login url' do
        User.should_receive(:load_from_reset_password_token).with('').and_return(nil)
        put :update, id: user.reset_password_token, token: '', user: {email: user.email, password: "validpass", password_confirmation: "validpass"}
        expect(response).to redirect_to(login_url)
      end

    end

    context 'when submitting an invalid token' do

      it 'redirects the user to the login url' do
        User.should_receive(:load_from_reset_password_token).with('invalid').and_return(nil)
        put :update, id: user.reset_password_token, token: 'invalid', user: {email: user.email, password: "validpass", password_confirmation: "validpass"}
        expect(response).to redirect_to(login_url)
      end

    end

    context 'when not submitting a password' do

      before :each do
        User.should_receive(:load_from_reset_password_token).with(user.reset_password_token).and_return(user)
      end

      it 'renders the new template' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: nil, password_confirmation: "validpass"}
        expect(response).to render_template :edit
      end

      it 'shows an error' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: nil, password_confirmation: "validpass"}
        expect(response.body).to include(I18n.t("activerecord.errors.models.user.attributes.password.blank"))
      end

    end

    context 'when not submitting a password confirmation' do

      before :each do
        User.should_receive(:load_from_reset_password_token).with(user.reset_password_token).and_return(user)
      end

      it 'renders the new template' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: nil}
        expect(response).to render_template :edit
      end

      it 'shows an error' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: nil}
        expect(response.body).to include(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.blank"))
      end

    end

    context 'when password confirmation and password doesn\'t match' do

      before :each do
        User.should_receive(:load_from_reset_password_token).with(user.reset_password_token).and_return(user)
      end

      it 'renders the new template' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: "validpas"}
        expect(response).to render_template :edit
      end

      it 'shows an error' do
        put :update, id: user.reset_password_token, token: user.reset_password_token, user: {email: user.email, password: "validpass", password_confirmation: "validpas"}
        expect(response.body).to include(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
      end

    end

  end

end

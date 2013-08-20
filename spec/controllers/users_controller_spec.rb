require 'spec_helper'

describe UsersController do
  render_views
  
  describe '#new' do
    
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end
    
  end
  
  describe "#create" do

    context 'when sending all required fields' do

      it 'logs in the user' do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(session[:user_id]).to eq(assigns(:user).id)
      end

      it 'redirects the user to the home page' do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to(root_url)
      end
      
    end
    
    context 'when not specifying the email' do
      
      it 'shows an error' do
        post :create, user: FactoryGirl.attributes_for(:user, email: nil)
        expect(response.body).to include(I18n.t('activerecord.errors.models.user.attributes.email.blank'))
      end
      
    end
    
    context 'when not specifying the password' do
      
      it 'shows an error' do
        post :create, user: FactoryGirl.attributes_for(:user, password: nil)
        expect(response.body).to include(I18n.t('activerecord.errors.models.user.attributes.password.blank'))
      end
      
    end
    
    context 'when not specifying the password confirmation' do
      
      it 'shows an error' do
        post :create, user: FactoryGirl.attributes_for(:user, password_confirmation: nil)
        expect(response.body).to include(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank'))
      end
      
    end
    
    context 'when password and confirmation doesn\'t match' do
      
      it 'shows an error' do
        post :create, user: FactoryGirl.attributes_for(:user, :password_does_not_match)
        expect(response.body).to include(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation'))
      end
      
    end
    
    context 'when specifying the role attribute' do
      
      it 'filters the param' do
        post :create, user: FactoryGirl.attributes_for(:user, role: "admin")
        expect(assigns(:user).role).to eq('user')
      end
      
    end
    
    context 'when specifying the deleted attribute' do
      
      it 'filters the param' do
        post :create, user: FactoryGirl.attributes_for(:user, deleted: true)
        expect(assigns(:user).deleted).to eq(false)
      end
      
    end
    
  end

end

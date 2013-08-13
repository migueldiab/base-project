require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'new'" do
    
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
  end
  
  describe "POST 'create'" do
    
    context 'when sending all required fields' do
      
      it 'should redirect the user to the home page' do
        post :create, user: { email: 'test@test.com', password: '123456789', password_confirmation: '123456789' }
        response.should redirect_to('/')
      end
      
    end
    
    context 'when not specifying the email' do
      
      it 'should show an error' do
        post :create, user: { password: '123456789', password_confirmation: '123456789' }
        response.body.should include(I18n.t('activerecord.errors.models.user.attributes.email.blank'))
      end
      
    end
    
    context 'when not specifying the password' do
      
      it 'should show an error' do
        post :create, user: { email: 'test@test.com', password_confirmation: '123456789' }
        response.body.should include(I18n.t('activerecord.errors.models.user.attributes.password.blank'))
      end
      
    end
    
    context 'when not specifying the password confirmation' do
      
      it 'should show an error' do
        post :create, user: { email: 'test@test.com', password: '123456789' }
        response.body.should include(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank'))
      end
      
    end
    
    context 'when password and confirmation doesn\'t match' do
      
      it 'should show an error' do
        post :create, user: { email: 'test@test.com', password: '123456789', password_confirmation: '12345678' }
        response.body.should include(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation'))
      end
      
    end
    
    context 'when specifying the role attribute' do
      
      it 'should filter the param' do
        post :create, user: { email: 'test@test.com', password: '123456789', password_confirmation: '123456789', role: 'admin' }
        expect(User.last.role).to eq('user')
      end
      
    end
    
    context 'when specifying the deleted attribute' do
      
      it 'should filter the param' do
        post :create, user: { email: 'test@test.com', password: '123456789', password_confirmation: '123456789', deleted: true }
        expect(User.last.deleted).to eq(false)
      end
      
    end
    
  end

end

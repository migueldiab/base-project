require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it 'redirects to the homepage if the user is already logged in' do
      login_user(create(:user))
      get :new
      response.should redirect_to('/')
      # response.body.should include(I18n.t("auth.already_logged_message", logout_link: logout_path))
    end
    
  end

end

require 'spec_helper'

describe SessionsController do

  describe "#new" do
    
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
    
    it 'redirects to the root url if the user is already logged in' do
      login_user(create(:user))
      get :new
      expect(response).to redirect_to(root_url)
      # response.body.should include(I18n.t("auth.already_logged_message", logout_link: logout_path))
    end
    
  end

end

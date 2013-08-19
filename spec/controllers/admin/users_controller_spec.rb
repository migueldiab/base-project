require 'spec_helper'

describe Admin::UsersController do

  let(:current_user) { create(:user, :admin) }

  before :each do
    login_user current_user
  end

  describe '#index' do

    before :each do
      User.per_page = 10
    end

    context 'when requesting users' do

      let!(:user_1) { create(:user) }
      let!(:user_2) { create(:user) }
      let!(:user_3) { create(:user) }

      it 'retrieves a list of them' do
        get :index
        expect(assigns(:users)).to include(user_1, user_2, user_3)
      end

      it 'paginates them' do
        User.per_page = 2
        get :index
        expect(assigns(:users).size).to be(2)
      end

      it 'retrieves also deleted ones' do
        deleted_resource = create(:user, :deleted)
        get :index
        expect(assigns(:users)).to include(deleted_resource)
      end

    end

  end

  describe '#new' do

    it 'renders the correct view' do
      get :new
      expect(response.body).to render_template :new
    end

    it 'exposes a variable named user in a non persisted state' do
      get :new
      expect(assigns(:user)).to_not be_persisted
    end

  end

  describe '#create' do

    context 'when passing valid data' do

      it 'creates a user' do
        expect {
          post :create, user:FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it 'redirects to the user list' do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to(admin_users_url)
      end

    end

    context 'when passing invalid data' do
      render_views

      it 'renders the same view' do
        post :create, user: FactoryGirl.attributes_for(:user, :password_does_not_match)
        expect(response).to render_template :new
      end

      it 'shows an error' do
        post :create, user: FactoryGirl.attributes_for(:user, :password_does_not_match)
        expect(response.body).to include(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
      end

    end

    context 'when passing extra data' do

      it 'ignores it' do
        created_at = DateTime.now - 1.week
        post :create, user: FactoryGirl.attributes_for(:user, created_at: created_at)
        expect(User.last.created_at).to_not be(created_at)
      end

    end

  end

  describe '#edit' do
    render_views

    let(:user) { create(:user) }
    let(:deleted_user) { create(:user, :deleted) }

    it 'renders the correct view' do
      get :edit, id: user.id
      expect(response.body).to render_template :edit
    end

    it 'renders the correct view for deleted users' do
      get :edit, id: deleted_user.id
      expect(response.body).to render_template :edit
    end

    it 'exposes a variable named user with the correct user' do
      get :edit, id: user.id
      expect(assigns(:user)).to eq(user)
    end

  end

  describe '#update' do

    let(:user) { create(:user) }
    let(:deleted_user) { create(:user, :deleted) }

    context 'when passing valid data' do

      it 'updates the user' do
        email = "other@email.com"
        put :update, id: user.id, user: {email: email}
        expect(User.unscoped.find(user.id).email).to eq(email)
      end

      it 'redirects to the user list' do
        put :update, id: user.id, user: {email: "other@email.com"}
        expect(response).to redirect_to(admin_users_url)
      end

      describe 'and the user is deleted' do
        let(:deleted_user) { create(:user, :deleted) }

        it 'updates the user' do
          email = "other@email.com"
          put :update, id: deleted_user.id, user: {email: email}
          expect(User.unscoped.find(deleted_user.id).email).to eq(email)
        end

        it 'redirects to the user list' do
          put :update, id: deleted_user.id, user: {email: "other@email.com"}
          expect(response).to redirect_to(admin_users_url)
        end

      end

    end

    context 'when passing invalid data' do
      render_views

      it 'renders the same view' do
        put :update, id: user.id, user: {email: ""}
        expect(response).to render_template :edit
      end

      it 'shows an error' do
        put :update, id: user.id, user: {email: ""}
        expect(response.body).to include(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
      end

    end

    context 'when passing extra data' do

      it 'ignores it' do
        created_at = DateTime.now - 1.week
        put :update, id: user.id, user: {created_at: created_at}
        expect(User.unscoped.find(user.id).created_at).to_not be(created_at)
      end

    end

  end

  describe '#destroy' do

    let(:user) { create(:user) }
    let(:deleted_user) { create(:user, :deleted) }

    context 'when passing valid data' do

      it 'deletes the user' do
        to_delete = create(:user)
        expect {
          delete :destroy, id: to_delete.id
        }.to change(User, :count).by(-1)
      end

      it 'redirects to the user list' do
        delete :destroy, id: user.id
        expect(response).to redirect_to admin_users_url
      end

      describe 'and the user is deleted' do

        it 'redirects to the user list' do
          delete :destroy, id: deleted_user.id
          expect(response).to redirect_to admin_users_url
        end

      end

    end

  end

end

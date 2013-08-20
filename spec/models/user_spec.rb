require 'spec_helper'

describe User do

  context 'when creating a user' do

    it 'validates the password presence' do
      user = User.create FactoryGirl.attributes_for :user, password: nil
      expect(user.errors.messages[:password]).to include(I18n.t("activerecord.errors.models.user.attributes.password.blank"))
    end

    it 'validates the email presence' do
      user = User.create FactoryGirl.attributes_for :user, email: nil
      expect(user.errors.messages[:email]).to include(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
    end

    it 'validates the email uniqueness' do
      user = create(:user)
      another_user = User.create FactoryGirl.attributes_for :user, email: user.email
      expect(another_user.errors.messages[:email]).to include(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
    end

    it 'validates the password confirmation' do
      user = User.create FactoryGirl.attributes_for :user, password_confirmation: nil
      expect(user.errors.messages[:password_confirmation]).to include(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.blank"))
    end

    it 'validates password and confirmation' do
      user = User.create FactoryGirl.attributes_for :user, :password_does_not_match
      expect(user.errors.messages[:password_confirmation]).to include(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
    end

  end

  context 'when updating a user' do

    let(:user) { create(:user) }

    it 'validates the email presence' do
      user.email = nil
      user.save
      expect(user.errors.messages[:email]).to include(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
    end

    it 'validates the email uniqueness' do
      another_user = create(:user)
      user.email = another_user.email
      user.save
      expect(user.errors.messages[:email]).to include(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
    end

  end

end

require "spec_helper"

describe UserMailer do

  describe 'reset password email' do
    let(:user) { create(:user) }

    before :each do
      user.stub(:reset_password_token) { "sometoken" }
    end

    let(:mail) { UserMailer.reset_password_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t("auth.emails.password_reset.subject"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([I18n.t("app.email")])
    end

    it 'renders the greeting in the body' do
      expect(mail.body.encoded).to include(I18n.t("auth.emails.password_reset.greeting", email: user.email))
    end

    it 'renders the introduction in the body' do
      expect(mail.body.encoded).to include(I18n.t("auth.emails.password_reset.introduction", site_name: I18n.t("app.name")))
    end

    it 'renders the action in the body' do
      expect(mail.body.encoded).to include(I18n.t("auth.emails.password_reset.action", link: edit_password_reset_url(user.reset_password_token)))
    end

  end

end

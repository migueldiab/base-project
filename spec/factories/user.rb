FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@project.com"
  end

  factory :user do
    email
    password "foobar"
    password_confirmation "foobar"
  end
end

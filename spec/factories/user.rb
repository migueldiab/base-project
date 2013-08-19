FactoryGirl.define do

  sequence :email do |n|
    "email#{n}@project.com"
  end

  factory :user do
    email
    password "foobar"
    password_confirmation "foobar"
    role "user"

    trait :password_does_not_match do
      password "foobar"
      password_confirmation "foobar1"
    end

    trait :deleted do
      deleted true
    end

    trait :admin do
      role "admin"
    end

  end

end

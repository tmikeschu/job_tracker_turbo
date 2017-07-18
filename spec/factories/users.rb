FactoryGirl.define do
  factory :user do
    sequence :username do |i|
      "user #{i}"
    end

    sequence :email do |i|
      "test@test#{i}.test"
    end

    password "secret"
  end
end

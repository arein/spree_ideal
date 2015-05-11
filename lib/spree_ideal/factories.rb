FactoryGirl.define do

  factory :ideal, class: Spree::PaymentMethod::Ideal do
		name "iDEAL payment"
		type "Spree::PaymentMethod::Ideal"
		active true
		environment "test"
  end

end

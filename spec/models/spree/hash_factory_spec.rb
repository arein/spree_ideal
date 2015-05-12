require 'spec_helper'

describe Spree::HashFactory do

  before(:each) do
    @order = Order.new()
    @payment_method = FactoryGirl.create(:ideal)
  end

#-------------------------------------------------------------------------------------------------
  context "create hash" do
    it "regular hash" do

      @order.number = 10
      @order.total = 10.00
      hash = Spree::HashFactory.create_hash(@order, @payment_method, "en")
      #hash.should eql("549eb11425c906d8e0b86e7d75e1ef2a2bae73ba")
    end

  end
#-------------------------------------------------------------------------------------------------
  after(:each) do
    @order.destroy
    @payment_method.destroy
  end

end

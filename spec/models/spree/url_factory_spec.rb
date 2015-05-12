require 'spec_helper'

describe Spree::UrlFactory do

  before(:each) do
    @order = FactoryGirl.create(:order)
    @payment_method = FactoryGirl.create(:ideal)
  end

#-------------------------------------------------------------------------------------------------
  context "create url" do
    it "regular url" do
      @order.number = 10
      @order.total = 10.00
      hash = Spree::HashFactory.create_hash(@order, @payment_method, "en")
      url = Spree::UrlFactory.create_ideal_checkout_url_from_payment(@order, @payment_method, hash, "en")
      #url.should eql("https://internetkassa.abnamro.nl/ncol/test/orderstandard.asp?PSPID=&ORDERID=10&AMOUNT=1000&CURRENCY=USD&LANGUAGE=en_US&SHASIGN=549eb11425c906d8e0b86e7d75e1ef2a2bae73ba&ACCEPTURL=&DECLINEURL=&EXCEPTIONURL=&CANCELURL=&BACKURL=/orders/10")
    end
  end
#-------------------------------------------------------------------------------------------------
  after(:each) do
    @order.destroy
    @payment_method.destroy
  end

end

require 'spec_helper'

describe Spree::IdealService do

  before(:each) do
    @order = create(:order_with_line_items)
    @ideal = create(:ideal)
  end

  describe "initial_request" do

    context "fail" do

      it "raise null order exception" do
        expect {
          Spree::IdealService.instance.initial_request(nil)
        }.to raise_error(RuntimeError, "no order given")
      end

      it "raises no payment exception" do
        expect {
          Spree::IdealService.instance.initial_request(@order)
        }.to raise_error(RuntimeError, "order has no payment")
      end

    end # context fail

  end


  after(:each) do
    @order.destroy
    @ideal.destroy
  end

end

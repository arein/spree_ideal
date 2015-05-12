require 'spec_helper'

describe Spree::IdealService do

  before(:each) do
    @order = create(:order_with_line_items)
    @ideal = create(:ideal)
  end


  after(:each) do
    @order.destroy
    @ideal.destroy
  end

end

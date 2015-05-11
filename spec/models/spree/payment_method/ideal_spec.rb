require 'spec_helper'

describe Spree::PaymentMethod::Ideal do

  before(:all) do
    @ideal = create(:ideal)
  end

  describe "save preferences" do

    it "can save abn_url" do
      @ideal.set_preference(:abn_url, "the url")
      @ideal.save!
      @ideal.get_preference(:abn_url).should eql("the url")
    end

    it "can save pspid" do
      @ideal.set_preference(:pspid, "the url")
      @ideal.save!
      @ideal.get_preference(:pspid).should eql("the url")
    end

    it "can save accept_url" do
      @ideal.set_preference(:accept_url, "the url")
      @ideal.save!
      @ideal.get_preference(:accept_url).should eql("the url")
    end

    it "can save decline_url" do
      @ideal.set_preference(:decline_url, "the url")
      @ideal.save!
      @ideal.get_preference(:decline_url).should eql("the url")
    end

    it "can save exception_url" do
      @ideal.set_preference(:exception_url, "the url")
      @ideal.save!
      @ideal.get_preference(:exception_url).should eql("the url")
    end

    it "can save cancel_url" do
      @ideal.set_preference(:cancel_url, "the url")
      @ideal.save!
      @ideal.get_preference(:cancel_url).should eql("the url")
    end

    it "can save sha_in_pass_phrase" do
      @ideal.set_preference(:sha_in_pass_phrase, "the pass phrase")
      @ideal.save!
      @ideal.get_preference(:sha_in_pass_phrase).should eql("the pass phrase")
    end

    it "can save sha_out_pass_phrase" do
      @ideal.set_preference(:sha_out_pass_phrase, "the sha_out_pass_phrase")
      @ideal.save!
      @ideal.get_preference(:sha_out_pass_phrase).should eql("the sha_out_pass_phrase")
    end

    it "can save sha_algorithm" do
      @ideal.set_preference(:sha_algorithm, "the sha_algorithm")
      @ideal.save!
      @ideal.get_preference(:sha_algorithm).should eql("the sha_algorithm")
    end

    it "can save shop_base_url" do
      @ideal.set_preference(:shop_base_url, "the shop_base_url")
      @ideal.save!
      @ideal.get_preference(:shop_base_url).should eql("the shop_base_url")
    end

  end

  after(:all) do
    @ideal.destroy
  end

end

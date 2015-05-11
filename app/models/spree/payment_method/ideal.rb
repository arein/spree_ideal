# encoding: UTF-8
module Spree
  class PaymentMethod::Ideal < PaymentMethod::Check
    preference :abn_url, :string, :default => "https://internetkassa.abnamro.nl/ncol/test/orderstandard.asp"
    preference :pspid, :string, :default => ""
    preference :accept_url, :string, :default => ""
    preference :decline_url, :string, :default => ""
    preference :exception_url, :string, :default => ""
    preference :cancel_url, :string, :default => ""
    preference :sha_in_pass_phrase, :string, :default => ""
    preference :sha_out_pass_phrase, :string, :default => ""
    preference :sha_algorithm, :string, :default => "SHA-1"
    preference :shop_base_url, :string, :default => ""
  end
end

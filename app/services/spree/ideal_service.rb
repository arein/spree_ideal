module Spree
  class IdealService

    include Singleton

    # make the initialization request
    def initial_request order, ref_number=nil
      init_data_by_order(order) # Some Validation
      # Security Validations
      raise I18n.t("ideal.no_sha_in_passphrase") if @order.last_payment.payment_method.preferred_sha_in_pass_phrase.blank?
      raise I18n.t("ideal.no_sha_out_passphrase") if @order.last_payment.payment_method.preferred_sha_out_pass_phrase.blank?
      raise I18n.t("ideal.invalid_hash_algorithm") unless ["SHA-1", "SHA-256", "SHA-512"].include?(@order.last_payment.payment_method.preferred_sha_algorithm)

      # Hash
      hash = Spree::HashFactory.create_hash(order, order.last_payment.payment_method, I18n.locale).upcase
      order.last_payment.update_attribute(:ideal_hash, hash)
      order.save!
    end

    private

    def init_data_by_order(order)
      raise I18n.t("ideal.no_order_given") if order.blank?
      @order = order

      raise I18n.t("ideal.order_has_no_payment") if @order.last_payment.blank?
      raise I18n.t("ideal.order_has_no_payment_method") if @order.last_payment_method.blank?
      raise I18n.t("ideal.orders_payment_method_is_not_ideal") unless @order.last_payment_method.kind_of? Spree::PaymentMethod::Ideal
    end
  end
end

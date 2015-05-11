Spree::CheckoutController.class_eval do
  before_filter :redirect_to_ideal, :only => [:update]

  def redirect_to_ideal
    return unless (params[:state] == "payment")
    return unless params[:order][:payments_attributes]

    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

    if payment_method.kind_of?(Spree::PaymentMethod::Ideal)
      @order.update_from_params(params, permitted_checkout_attributes)

      Spree::IdealService.instance.initial_request(@order)

      # Create iDEAL Url
      redirect_url = Spree::UrlFactory.create_ideal_checkout_url_from_payment(@order, payment_method, @order.last_payment.ideal_hash, I18n.locale)
      redirect_to redirect_url, :status => 302
    end
  end

end

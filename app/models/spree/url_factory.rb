class Spree::UrlFactory
  def self.create_ideal_checkout_url_from_payment(order, ideal_payment_settings, hash, locale)

    total = (order.total * 100).to_i # Convert according to

    language = Spree::IdealCountryUtil.format_locale(locale)

    url = ideal_payment_settings.preferred_abn_url + ""\
        "?PSPID=" + ideal_payment_settings.preferred_pspid + ""\
        "&ORDERID=" + order.number.to_s + ""\
        "&AMOUNT=" + total.to_s + "" \
        "&CURRENCY=" + Spree::Config.currency.to_s + "" \
        "&LANGUAGE=" + language + ""\
        "&SHASIGN=" + hash + ""\
        "&ACCEPTURL=" + ideal_payment_settings.preferred_accept_url + ""\
        "&DECLINEURL=" + ideal_payment_settings.preferred_decline_url + ""\
        "&EXCEPTIONURL=" + ideal_payment_settings.preferred_exception_url + ""\
        "&CANCELURL=" + ideal_payment_settings.preferred_cancel_url + ""\
        "&BACKURL=" + ideal_payment_settings.preferred_shop_base_url + "/orders/#{order.number}"
  end
end
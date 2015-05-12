class Spree::HashFactory
  def self.create_hash(order, ideal_payment_settings, locale)

    secret = ideal_payment_settings.preferred_sha_in_pass_phrase.to_s

    language = Spree::IdealCountryUtil.format_locale(locale.to_s)

    if secret.blank?
      secret = "" # Fallback if secret not set
    end

    total = (order.total * 100).to_i # Convert according to
    to_hash = "ACCEPTURL=" + ideal_payment_settings.preferred_accept_url + secret + "" \
              +  "AMOUNT=" + total.to_s + secret + ""\
              +  "BACKURL=" + ideal_payment_settings.preferred_shop_base_url + "/ideal/back" + secret + "" \
              +  "CANCELURL=" + ideal_payment_settings.preferred_cancel_url + secret + "" \
              +  "CURRENCY=" + Spree::Config.currency.to_s + secret + "" \
              +  "DECLINEURL=" + ideal_payment_settings.preferred_decline_url + secret + "" \
              +  "EXCEPTIONURL=" + ideal_payment_settings.preferred_exception_url + secret + "" \
              +  "LANGUAGE=" + language + secret + "" \
              +  "ORDERID=" + order.number.to_s + secret + "" \
              +  "PSPID=" + ideal_payment_settings.preferred_pspid.to_s + secret + "" \

    case ideal_payment_settings.preferred_sha_algorithm
      when "SHA-1"
        Digest::SHA1.hexdigest to_hash
      when "SHA-256"
        Digest::SHA256.hexdigest to_hash
      when "SHA-512"
        Digest::SHA512.hexdigest to_hash
      else
        Digest::SHA1.hexdigest to_hash
    end
  end

  def self.create_sha_out_hash(params, secret, hash_algorithm)

    if secret.blank?
      return secret
    end

    to_hash = "ACCEPTANCE=" + params[:ACCEPTANCE] + secret + ""\
              +  "AMOUNT=" + params[:amount] + secret + "" \
              +  "BRAND=" + params[:BRAND] + secret + "" \
              +  "CARDNO=" + params[:CARDNO] + secret + "" \
              +  "CURRENCY=" + params[:currency] + secret + "" \
              +  "NCERROR=" + params[:NCERROR] + secret + "" \
              +  "ORDERID=" + params[:orderID] + secret + "" \
              +  "PAYID=" + params[:PAYID] + secret + "" \
              +  "PM=" + params[:PM] + secret + "" \
              +  "STATUS=" + params[:STATUS] + secret + "" \

    case hash_algorithm
      when "SHA-1"
        Digest::SHA1.hexdigest to_hash
      when "SHA-256"
        Digest::SHA256.hexdigest to_hash
      when "SHA-512"
        Digest::SHA512.hexdigest to_hash
      else
        Digest::SHA1.hexdigest to_hash
    end
  end
end
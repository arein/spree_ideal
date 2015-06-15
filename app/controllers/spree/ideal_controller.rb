class Spree::IdealController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:status, :back]
  skip_before_action :verify_authenticity_token, :only => :back

  def success
    if params.blank? or params[:orderID].blank?
      flash[:error] = I18n.t("ideal.order_invalid_setup")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    # Some Validation
    if !params.has_key?("currency") || params[:currency].blank? ||
        !params.has_key?("amount") || params[:amount].blank? ||
        !params.has_key?("PM") || params[:PM].blank? ||
        !params.has_key?("CARDNO") || params[:CARDNO].blank? ||
        !params.has_key?("STATUS") || params[:STATUS].blank? ||
        !params.has_key?("PAYID") || params[:PAYID].blank? ||
        !params.has_key?("NCERROR") || params[:NCERROR].blank? ||
        !params.has_key?("BRAND") || params[:BRAND].blank?
      flash[:error] = I18n.t("ideal.order_invalid_setup")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    order = Spree::Order.where(number: params[:orderID]).take

    if order.nil?
      Rails.logger.warn("Order is nil")
      flash[:error] = I18n.t("ideal.payment_not_found")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    ideal_payment = order.last_payment

    if ideal_payment.blank? or  !order.last_payment_method.kind_of? Spree::PaymentMethod::Ideal
      Rails.logger.warn("Payment is nil or not Ideal")
      flash[:error] = I18n.t("ideal.payment_not_found")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    hash_algorithm = ideal_payment.payment_method.preferred_sha_algorithm
    secret = ideal_payment.payment_method.preferred_sha_out_pass_phrase.to_s

    # Some Validation
    unless params.has_key?("SHASIGN")
      Rails.logger.warn("Hash is not present")
      flash[:error] = I18n.t("ideal.order_invalid_setup")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    # Security Validation
    shasign = ""
    if params.has_key?("SHASIGN")
      shasign = params[:SHASIGN].downcase
    end

    sha_out_hash = Spree::HashFactory.create_sha_out_hash(params, secret, hash_algorithm)

    unless sha_out_hash.eql? shasign
      Rails.logger.warn("Hashes do not match")
      flash[:error] = I18n.t("ideal.security_error")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    if not order.state.eql? "complete" and not order.state.eql? "payment" and not order.state.eql? "checkout"
      Rails.logger.warn("Order is in an invalid state")
      flash[:error] = I18n.t("ideal.order_invalid_state")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    if order.state.eql? "complete"  # complete again via browser back or recalling ideal "go" url
      # The default behavior is to accept multiple calls to this URL
      # In general, this URL should be called twice
      # (i.e. once by the user and once by the bank)
      # However, in some cases, e.g. when the user loses the connection
      # It is only called once
      if ideal_payment.ideal_log.blank?
        ideal_payment.update_attribute(:ideal_log, "payment confirmed again by either iDEAL or user,")
      else
        ideal_payment.update_attribute(:ideal_log, ideal_payment.ideal_log + "payment confirmed again by either iDEAL or user,")
      end
      ideal_payment.save!

      flash[:order_completed] = I18n.t("ideal.completed_successfully")
      success_redirect order
    else
      ActiveRecord::Base.transaction do
        ideal_payment.update_attribute(:ideal_transaction, params[:PAYID])
        if ideal_payment.ideal_log.blank?
          ideal_payment.update_attribute(:ideal_log, "payment_successful,")
        else
          ideal_payment.update_attribute(:ideal_log, ideal_payment.ideal_log + "payment_successful,")
        end
        ideal_payment.complete!
        order.finalize!
        order.state = "complete"
        order.save!
      end
      session[:order_id] = nil
      flash[:order_completed] = I18n.t("ideal.completed_successfully")
      success_redirect order
    end

  end

  def decline
    self.handle_status(params, "canceled")
    flash[:error] = I18n.t("ideal.decline")
    redirect_to '/checkout/payment', :status => 302
  end

  def exception
    self.handle_status(params, "exception")
    flash[:error] = I18n.t("ideal.exception")
    redirect_to '/checkout/payment', :status => 302
  end

  def cancel
    self.handle_status(params, "canceled")
    flash[:error] = I18n.t("ideal.canceled")
    redirect_to '/checkout/payment', :status => 302
  end

  def back
    self.handle_status(params, "back")
    redirect_to '/checkout/payment', :status => 302
  end

  def handle_status(params, message)
    if params.blank? or params[:orderID].blank?
      return
    end

    order = Spree::Order.where(number: params[:orderID]).take

    if order.nil?
      return
    end

    unless order.last_payment_method.kind_of? Spree::PaymentMethod::Ideal
      return
    end

    ideal_payment = order.last_payment

    if ideal_payment.blank?
      return
    end

    if ideal_payment.ideal_log.blank?
      ideal_payment.update_attribute(:ideal_log, message + ",")
    else
      ideal_payment.update_attribute(:ideal_log, ideal_payment.ideal_log + message + ",")
    end
    ideal_payment.save!

  end

  def success_redirect order
    redirect_to "/orders/#{order.number}", :status => 302
  end
end

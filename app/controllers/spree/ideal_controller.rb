require 'pp'
require 'uri'

class Spree::IdealController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :status

  def success

    if params[:orderID].blank?
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

    ideal_payment = Spree::Payment.where(order_id: params[:orderID]).take

    if params.blank? or ideal_payment.blank?
       flash[:error] = I18n.t("ideal.payment_not_found")
       redirect_to '/checkout/payment', :status => 302
       return
    end

    hash_algorithm = ideal_payment.payment_method.preferred_sha_algorithm
    secret = ideal_payment.payment_method.preferred_sha_out_pass_phrase.to_s

    # Some Validation
    unless params.has_key?("SHASIGN")
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

    pp sha_out_hash
    unless sha_out_hash.eql? shasign
      flash[:error] = I18n.t("ideal.security_error")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    order = ideal_payment.order
    if order.blank?
     	flash[:error] = I18n.t("ideal.order_not_found")
     	redirect_to '/checkout/payment', :status => 302
     	return
    end

    if not order.state.eql? "complete" and not order.state.eql? "payment" and not order.state.eql? "checkout"
      flash[:error] = I18n.t("ideal.order_invalid_state")
      redirect_to '/checkout/payment', :status => 302
      return
    end

    if order.state.eql? "complete"  # complete again via browser back or recalling ideal "go" url
      success_redirect order
    else
      order.finalize!
      order.state = "complete"
      order.save!
      session[:order_id] = nil
      flash[:success] = I18n.t("ideal.completed_successfully")
      success_redirect order
    end

  end

  def decline
    flash[:error] = I18n.t("ideal.decline")
    redirect_to '/checkout/payment', :status => 302
  end

  def exception
    flash[:error] = I18n.t("ideal.exception")
    redirect_to '/checkout/payment', :status => 302
  end

  def cancel
    flash[:error] = I18n.t("ideal.canceled")
    redirect_to '/checkout/payment', :status => 302
  end

  private

  def success_redirect order
    redirect_to "/orders/#{order.number}", :status => 302
  end

end

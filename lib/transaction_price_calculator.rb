# frozen_string_literal: true
require File.expand_path('../provider_size_price.rb', __FILE__)
require File.expand_path('../discount_rules.rb', __FILE__)

class TransactionPriceCalculator
  def initialize(date, size, provider, member_discount_history)
    @date = date
    @size = size
    @shipping_provider = provider
    @member_discount_history = member_discount_history
  end

  def transaction_price
    shipping_with_discount = shipping_discount
    if shipping_price == shipping_with_discount
      "#{"%.2f"%shipping_price} -"
    else
      "#{"%.2f"%shipping_with_discount} #{"%.2f"%(shipping_price-shipping_with_discount)}"
    end

  end

  def shipping_discount
    discount = DiscountRules.new(@date, @size, @shipping_provider, shipping_price, @member_discount_history).transaction_discount
    return discount unless discount.nil?
    shipping_price
  end

  def shipping_price
    ProviderSizePrice.shipping_price(@shipping_provider, @size)
  end
end

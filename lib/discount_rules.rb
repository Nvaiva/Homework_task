require File.expand_path('../provider_size_price.rb', __FILE__)
require 'bigdecimal'

class DiscountRules
  MONTH_DISCOUNT_LIMIT = BigDecimal(10,2)

  def initialize(date, size, shipping_provider, original_price, member_discount_history)
    @year_and_month = date[0..6]
    @size = size
    @shipping_provider = shipping_provider
    @original_price = original_price
    @member_discount_history = member_discount_history
    @remaining_discounts = @member_discount_history.remaining_discount_for_month(@year_and_month, MONTH_DISCOUNT_LIMIT)
  end

  def transaction_discount
    return if @remaining_discounts <= 0
    rule_lowest_price = lowest_price_s_package
    rule_third_l_lp_free = third_l_lp_free
    rule_lowest_price || rule_third_l_lp_free
  end

  def lowest_price_s_package
    return if @size != 'S'

    lowest_price = ProviderSizePrice.lowest_s_package_shipping_price
    price_difference = @original_price - lowest_price

    if @remaining_discounts - price_difference > 0
      @member_discount_history.member_used_discounts_per_month[@year_and_month] += price_difference
      lowest_price
    else
      @member_discount_history.member_used_discounts_per_month[@year_and_month] += @remaining_discounts
      @original_price - @remaining_discounts
    end
  end

  def third_l_lp_free
    return if @size != 'L'
    return if @shipping_provider != 'LP'

    @member_discount_history.member_LP_shipping_L_size[@year_and_month] += 1

    if @member_discount_history.member_LP_shipping_L_size[@year_and_month] == 3
      if @remaining_discounts - @original_price > 0
        @member_discount_history.member_used_discounts_per_month[@year_and_month] += @original_price
        return 0
      else
        @member_discount_history.member_used_discounts_per_month[@year_and_month] += @remaining_discounts
        return @original_price - @remaining_discounts
      end
    end
  end
end

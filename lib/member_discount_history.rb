# frozen_string_literal: true
require 'bigdecimal'

class MemberDiscountHistory
  attr_accessor :member_used_discounts_per_month, :member_LP_shipping_L_size
  def initialize
    @member_used_discounts_per_month = Hash.new(BigDecimal("0",2))
    @member_LP_shipping_L_size = Hash.new(0)
  end

  def remaining_discount_for_month(year_and_month, discount_limit)
    discount_limit - @member_used_discounts_per_month[year_and_month]
  end
end

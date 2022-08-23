# frozen_string_literal: true
require 'bigdecimal'

class ProviderSizePrice

  PROVIDER_SIZE_PACKAGE = {
    'LP' => {
      'S' => BigDecimal(1.5,2),
      'M' => BigDecimal(4.9,2),
      'L' => BigDecimal(6.9,2),
    },
    'MR' => {
      'S' => BigDecimal(2,2),
      'M' => BigDecimal(3,2),
      'L' => BigDecimal(4,2),
    }
  }

  LOWEST_S_PACKAGE_SHIPPING_PRICE = PROVIDER_SIZE_PACKAGE.collect { |_, value| value['S'] }.min

  def self.shipping_price(provider, package_size)
    PROVIDER_SIZE_PACKAGE&.dig(provider)&.dig(package_size)
  end

  def self.lowest_s_package_shipping_price
    LOWEST_S_PACKAGE_SHIPPING_PRICE
  end

  def self.size_present?(size)
    PROVIDER_SIZE_PACKAGE.keys.any? { |k| PROVIDER_SIZE_PACKAGE[k].key?(size) }
  end

  def self.provider_present?(provider)
    PROVIDER_SIZE_PACKAGE.key?(provider)
  end
end
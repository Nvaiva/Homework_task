require File.expand_path('../provider_size_price.rb', __FILE__)
require 'date'

class DataValidator

  def self.valid_transaction_data?(date, size, provider)
    valid_date?(date) && valid_size?(size) && valid_provider?(provider)
  end

  def self.valid_date?(date)
    Date.parse(date).strftime("%Y-%m-%d") == date rescue false
  end

  def self.valid_size?(size)
    ProviderSizePrice.size_present?(size)
  end

  def self.valid_provider?(provider)
    ProviderSizePrice.provider_present?(provider)
  end
end

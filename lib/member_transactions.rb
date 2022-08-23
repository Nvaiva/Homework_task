# frozen_string_literal: true
require File.expand_path('../transaction_price_calculator.rb', __FILE__)
require File.expand_path('../member_discount_history.rb', __FILE__)
require File.expand_path('../data_validator.rb', __FILE__)

class MemberTransactions
  def initialize(member_transactions_file)
    @member_transactions_file = member_transactions_file
    @member_discount_history = MemberDiscountHistory.new
  end

  def member_transactions_with_discount
    File.readlines(@member_transactions_file).each do |line|
      transaction = line.split("\s")

      date = transaction[0]
      size = transaction[1]
      provider = transaction[2]

      if DataValidator.valid_transaction_data?(date, size, provider) && transaction.length == 3
        result = TransactionPriceCalculator.new(date, size, provider, @member_discount_history).transaction_price
        puts "#{date} #{size} #{provider} #{result}"
      else
        puts "#{date} #{size} #{provider} Ignored"
      end
    end
  end
end

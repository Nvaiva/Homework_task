require File.expand_path('../../lib/transaction_price_calculator.rb', __FILE__)
require File.expand_path('../../lib/member_discount_history.rb', __FILE__)

RSpec.describe TransactionPriceCalculator do
  subject { described_class.new(date, size, provider, member_discount_history) }

  context '#transaction_price' do
    let(:date) { '2022-08-23' }
    let(:year_and_month) { date[0..6] }
    let(:size) { 'S' }
    let(:provider) { 'MR' }
    let(:member_discount_history) { MemberDiscountHistory.new }
    let(:default_price) { subject.shipping_price }

    context 'when discount was not applicable' do
      let(:expected_return) { "#{"%.2f"%default_price} -" }
      it 'returns default transaction price with a dash symbol' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(MONTH_DISCOUNT_LIMIT, 2)

        expect(subject.transaction_price).to eq(expected_return)
      end
    end

    context 'when discount was applicable' do
      it 'returns discounted price and a discount' do
        price_with_a_discount = subject.shipping_discount
        discount = default_price - price_with_a_discount
        expect(subject.transaction_price).to eq("#{"%.2f"%price_with_a_discount} #{"%.2f"%discount}")
      end
    end
  end
end


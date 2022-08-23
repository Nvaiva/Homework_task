require File.expand_path('../../lib/discount_rules.rb', __FILE__)
require File.expand_path('../../lib/provider_size_price.rb', __FILE__)
require File.expand_path('../../lib/member_discount_history.rb', __FILE__)

RSpec.describe DiscountRules do
  subject { described_class.new(date, size, shipping_provider, original_price, member_discount_history) }

  let(:date) { '2022-08-21' }

  describe '#transaction_discount' do
    let(:shipping_provider) { 'LP' }
    let(:size) { 'S' }
    let(:original_price) { 2 }
    let(:member_discount_history) { MemberDiscountHistory.new }
    let(:year_and_month) { date[0..6] }

    context 'when there are no remaining discounts' do
      it 'returns nil' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(MONTH_DISCOUNT_LIMIT, 2)
        expect(subject.transaction_discount).to eq(nil)
      end
    end

    context 'when there are remaining discounts and one rule was applicable' do
      it 'returns price with a discount' do
        expect(subject.transaction_discount).not_to eq(nil)
      end
    end

    context 'when there are remaining discounts but no rule was applicable' do
      let(:shipping_provider) { 'MR' }
      let(:size) { 'L' }
      it 'returns nil' do
        expect(subject.transaction_discount).to eq(nil)
      end
    end
  end

  describe '#lowest_price_s_package' do
    let(:shipping_provider) { 'LP' }
    let(:size) { 'S' }
    let(:original_price) { 2 }
    let(:member_discount_history) { MemberDiscountHistory.new }
    let(:year_and_month) { date[0..6] }

    context 'when there are enough remaining discounts' do
      it 'returns lowest s package price' do
        expect(subject.lowest_price_s_package).to eq(ProviderSizePrice.lowest_s_package_shipping_price)
      end
    end

    context 'when there are partially enough remaining discounts' do
      it 'returns original s package price - remaining discount' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(9.9, 2)
        remaining_discount_for_month = member_discount_history.remaining_discount_for_month(year_and_month, MONTH_DISCOUNT_LIMIT)
        expect(subject.lowest_price_s_package).to eq(original_price - remaining_discount_for_month)
      end
    end

    context 'when there are no remaining discounts' do
      it 'returns original s package price' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(MONTH_DISCOUNT_LIMIT, 2)
        expect(subject.lowest_price_s_package).to eq(original_price)
      end
    end

    context 'when package size is not S' do
      let(:size) { 'M' }

      it 'returns nil' do
        expect(subject.lowest_price_s_package).to eq(nil)
      end
    end
  end

  describe '#third_l_lp_free' do
    let(:shipping_provider) { 'LP' }
    let(:size) { 'L' }
    let(:original_price) { 7 }
    let(:member_discount_history) { MemberDiscountHistory.new }
    let(:year_and_month) { date[0..6] }

    context 'when it is a third L LP package and enough remaining discounts' do
      it 'returns 0' do
        member_discount_history.member_LP_shipping_L_size[year_and_month] = 2
        expect(subject.third_l_lp_free).to eq(0)
      end
    end

    context 'when it is a third L LP package and partially enough remaining discounts' do
      it 'returns value equal to original L LP package - remaining discounts' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_LP_shipping_L_size[year_and_month] = 2
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(9.9, 2)
        remaining_discount_for_month = member_discount_history.remaining_discount_for_month(year_and_month, MONTH_DISCOUNT_LIMIT)
        expect(subject.third_l_lp_free).to eq(original_price - remaining_discount_for_month)
      end
    end

    context 'when it is a third L LP package and there are no remaining discounts' do
      it 'returns original L LP package price' do
        stub_const("MONTH_DISCOUNT_LIMIT", 10)
        member_discount_history.member_LP_shipping_L_size[year_and_month] = 2
        member_discount_history.member_used_discounts_per_month[year_and_month] = BigDecimal(MONTH_DISCOUNT_LIMIT, 2)
        expect(subject.third_l_lp_free).to eq(original_price)
      end
    end

    context 'when it is not a third L LP package' do
      it 'returns nil' do
        member_discount_history.member_LP_shipping_L_size[year_and_month] = 1
        expect(subject.third_l_lp_free).to eq(nil)
      end
    end

    context 'when package size is not L' do
      let(:size) { 'M' }

      it 'returns nil' do
        expect(subject.third_l_lp_free).to eq(nil)
      end
    end

    context 'when shipping provider is not LP' do
      let(:shipping_provider) { 'KR' }

      it 'returns nil' do
        expect(subject.third_l_lp_free).to eq(nil)
      end
    end
  end
end

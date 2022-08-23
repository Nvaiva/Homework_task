require File.expand_path('../../lib/member_discount_history.rb', __FILE__)

RSpec.describe MemberDiscountHistory do
  subject { described_class.new }

  describe '#remaining_discount_for_month' do
    let(:year_and_month) { '2022-08' }
    let(:discount_limit) { 10 }

    context 'when there are no discount history' do
      it 'returns value equal to discount limit' do
        expect(subject.remaining_discount_for_month(year_and_month, discount_limit)).to eq(discount_limit)
      end
    end

    context 'when discount history is present' do
      let(:used_discounts) { 9 }
      it 'returns remaining discounts' do
        subject.member_used_discounts_per_month[year_and_month] = used_discounts
        expect(
          subject.remaining_discount_for_month(year_and_month, discount_limit)
        ).to eq(discount_limit - used_discounts)
      end
    end
  end
end

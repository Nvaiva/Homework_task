require File.expand_path('../../lib/provider_size_price.rb', __FILE__)
require File.expand_path('../../spec/class_method_returns_examples.rb', __FILE__)

RSpec.describe ProviderSizePrice do
  subject { described_class }

  describe '.shipping_price' do
    context 'when shipping provider and package sizes are present' do
      let(:provider) { 'LP' }
      let(:size) { 'S' }
      let(:price) { 1.5 }

      it 'returns price' do
        expect(subject.shipping_price(provider, size)).to eq(price)
      end
    end

    context 'when shipping provider is not present in PROVIDER_SIZE_PRICE constant' do
      let(:provider) { 'ZP' }
      let(:size) { 'S' }

      it 'returns nil' do
        expect(subject.shipping_price(provider, size)).to eq(nil)
      end
    end

    context 'when size is not present in PROVIDER_SIZE_PRICE constant' do
      let(:provider) { 'ZP' }
      let(:size) { 'W' }

      it 'returns nil' do
        expect(subject.shipping_price(provider, size)).to eq(nil)
      end
    end
  end

  describe '.size_present?' do
    let(:class_method) { 'size_present?' }

    context 'when size is present in PROVIDER_SIZE_PRICE constant' do
      let(:arg) { 'S' }

      it_behaves_like 'returns true'
    end

    context 'when size is not present in PROVIDER_SIZE_PRICE constant' do
      let(:arg) { 'W' }

      it_behaves_like 'returns false'
    end
  end

  describe '.provider_present?' do
    let(:class_method) { 'provider_present?' }

    context 'when provider is present in PROVIDER_SIZE_PRICE constant' do
      let(:arg) { 'MR' }

      it_behaves_like 'returns true'
    end

    context 'when provider is present in  PROVIDER_SIZE_PRICE constant' do
      let(:arg) { 'WW' }

      it_behaves_like 'returns false'
    end
  end
end

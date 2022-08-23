require File.expand_path('../../lib/data_validator.rb', __FILE__)
require File.expand_path('../../lib/provider_size_price.rb', __FILE__)
require File.expand_path('../../spec/class_method_returns_examples.rb', __FILE__)

RSpec.describe DataValidator do
  subject { described_class }

  shared_examples 'calls ProviderSizePrice' do
    it 'calls ProviderSizePrice' do
      allow(ProviderSizePrice).to receive(provider_size_price_method).with(arg).and_return(expected_return)
    end
  end

  describe '.valid_date?' do
    let(:class_method) { 'valid_date?' }

    context 'when date is separated by a dash' do
      let(:arg) { '2022-08-20' }

      it_behaves_like 'returns true'
    end

    context 'when date is separated by a dot' do
      let(:arg) { '2015.01.02' }

      it_behaves_like 'returns false'
    end

    context 'when date is non existing' do
      let(:arg) { '2022-13-01' }

      it_behaves_like 'returns false'
    end

    context 'when date is a random string' do
      let(:arg) { 'miau' }

      it_behaves_like 'returns false'
    end
  end

  describe '.valid_size?' do
    let(:class_method) { 'valid_size?' }

    context 'when size is present in ShipmentPriceSize' do
      let(:arg) { 'S' }
      let(:provider_size_price_method) { 'size_present?' }
      let(:expected_return) { true }

      it_behaves_like 'calls ProviderSizePrice'
      it_behaves_like 'returns true'
    end

    context 'when size is not present in ShipmentPriceSize' do
      let(:arg) { 'W' }
      let(:provider_size_price_method) { 'size_present?' }
      let(:expected_return) { false }

      it_behaves_like 'calls ProviderSizePrice'
      it_behaves_like 'returns false'
    end
  end

  describe '.valid_provider?' do
    let(:class_method) { 'valid_provider?' }

    context 'when provider is present in ShipmentPriceSize' do
      let(:arg) { 'LP' }
      let(:provider_size_price_method) { 'provider_present?' }
      let(:expected_return) { true }

      it_behaves_like 'calls ProviderSizePrice'
      it_behaves_like 'returns true'
    end

    context 'when provider is not present in ShipmentPriceSize' do
      let(:arg) { 'W' }
      let(:provider_size_price_method) { 'provider_present?' }
      let(:expected_return) { false }

      it_behaves_like 'calls ProviderSizePrice'
      it_behaves_like 'returns false'
    end
  end
end

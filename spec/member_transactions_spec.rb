require File.expand_path('../../lib/member_transactions.rb', __FILE__)
require File.expand_path('../../lib/transaction_price_calculator.rb', __FILE__)
require 'tempfile'

RSpec.describe MemberTransactions do
  subject { described_class.new(member_transaction_file) }
  let(:date_1) { '2015-02-01 ' }
  let(:size_1) { 'S ' }
  let(:provider_1) { 'MR' }
  let(:date_2) { '2015-02-02 ' }
  let(:size_2) { 'S ' }
  let(:provider_2) { 'MR' }
  let(:file_first_line) { date_1 + size_1 + provider_1 + "\r\n" }
  let(:file_last_line) { date_2 + size_2 + provider_2 }
  let(:calculated_transaction_price) { '1.5 0.5' }
  let(:member_transaction_file) do
    Tempfile.new.tap do |f|
      f << file_first_line + file_last_line
      f.close
    end
  end

  before(:example) do
    allow_any_instance_of(TransactionPriceCalculator).to receive(:transaction_price).and_return(calculated_transaction_price)
  end

  shared_examples 'reads input file line by line' do
    it 'reads input file line by line' do
      expect(File.open(member_transaction_file.path).readlines).to eq([file_first_line, file_last_line])
    end
  end

  shared_examples 'prints out date, size, provider and word Ignored' do
    it 'prints out date, size, provider and word Ignored' do
      expect { subject.member_transactions_with_discount }.to output(expected_output).to_stdout
    end
  end

  context 'when file contains date, size, provider in each line' do
    let(:expected_first_line) { "#{date_1}#{size_1}#{provider_1} #{calculated_transaction_price}" }
    let(:expected_last_line) { "#{date_2}#{size_2}#{provider_2} #{calculated_transaction_price}" }
    let(:expected_output) { expected_first_line + "\n" + expected_last_line + "\n" }

    it_behaves_like 'reads input file line by line'

    it 'prints out date, size, provider and calculated price with a discount' do
      expect { subject.member_transactions_with_discount }.to output(expected_output).to_stdout
    end
  end

  context 'when file contains wrong data' do
    let(:expected_last_line) { "#{date_2}#{size_2}#{provider_2} #{calculated_transaction_price}" }
    let(:expected_output) { expected_first_line + "\n" + expected_last_line + "\n" }

    context 'when file contains wrong date' do
      let(:date_1) { '2022.08.23 ' }
      let(:expected_first_line) { "#{date_1}#{size_1}#{provider_1} Ignored" }

      it_behaves_like 'reads input file line by line'
      it_behaves_like 'prints out date, size, provider and word Ignored'
    end

    context 'when file contains wrong size' do
      let(:size_1) { 'W ' }
      let(:expected_first_line) { "#{date_1}#{size_1}#{provider_1} Ignored" }

      it_behaves_like 'reads input file line by line'
      it_behaves_like 'prints out date, size, provider and word Ignored'
    end

    context 'when file contains wrong shipping provider' do
      let(:provider_1) { 'miau' }
      let(:expected_first_line) { "#{date_1}#{size_1}#{provider_1} Ignored" }

      it_behaves_like 'reads input file line by line'
      it_behaves_like 'prints out date, size, provider and word Ignored'
    end
  end
end

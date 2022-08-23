require 'rake'

require File.expand_path('../lib/member_transactions.rb', __FILE__)
task :run do
  ARGV.each { |a| task a.to_sym do ; end }
  input_file = ARGV[1]
  raise ArgumentError, 'Please specify the input.txt file' if input_file.nil?
  raise StandardError, 'File extension should be txt' if File.extname(input_file) != '.txt'
  MemberTransactions.new(input_file).member_transactions_with_discount
end


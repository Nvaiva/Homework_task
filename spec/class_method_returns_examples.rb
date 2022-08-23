RSpec.shared_examples 'returns true' do
  it 'returns true' do
    expect(subject.public_send(class_method, arg)).to eq(true)
  end
end

RSpec.shared_examples 'returns false' do
  it 'returns false' do
    expect(subject.public_send(class_method, arg)).to eq(false)
  end
end



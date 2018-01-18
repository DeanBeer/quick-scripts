require 'nrb/delivery_pick_list/version'
describe NRB::DeliveryPickList do

  it 'responds to version' do
    expect(described_class).to respond_to(:version)
  end


  it 'version is a string' do
    expect(described_class.version).to be_a(String)
  end

end

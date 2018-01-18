$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'nrb/delivery_pick_list'

RSpec.configure do |config|
  config.order = :random
end

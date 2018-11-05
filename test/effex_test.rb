require "test_helper"

class EffexTest < Minitest::Test
  def test_it_implements_the_requested_api
    Effex::ExchangeRate.at(Date.today,'GBP','USD')
  end
end

require "test_helper"
require 'timecop'

class EffexTest < Minitest::Test
  def setup
    Timecop.freeze

    @source1_rates = [
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "USD",
        rate: 1.2345
      }
    ]
    source = Effex::Source::Test.new("source1", @source1_rates)

    repo = Effex::Repository::Memory.new
    Effex::Repository.register(:reference_rate, repo)
    Effex::ExchangeRate.load(source)
  end

  def teardown
    Timecop.return
  end

  def test_find_reference_rate
    repo = Effex::Repository.for(:reference_rate)
    rate = Effex::ExchangeRate.at(Date.today,'GBP','USD')
    assert rate.date == @source1_rates[0][:date]
    assert rate.base_currency == @source1_rates[0][:base_currency]
    assert rate.counter_currency == @source1_rates[0][:counter_currency]
    assert rate.rate == @source1_rates[0][:rate]
  end

  def test_does_not_find_missing_reference_rate
    repo = Effex::Repository.for(:reference_rate)
    refute Effex::ExchangeRate.at(Date.today,'GBP','JPY')
    refute Effex::ExchangeRate.at(Date.today,'JPY','USD')
    refute Effex::ExchangeRate.at(Date.tomorrow,'GBP','USD')
  end
end

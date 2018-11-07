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
      },
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "JPY",
        rate: 2.0
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

  def test_finds_reference_rate
    repo = Effex::Repository.for(:reference_rate)
    rates = Effex::ExchangeRate.all_at(Date.today,'GBP','USD')
    assert rates.length == 1
    assert rates[0].date == @source1_rates[0][:date]
    assert rates[0].base_currency == @source1_rates[0][:base_currency]
    assert rates[0].counter_currency == @source1_rates[0][:counter_currency]
    assert rates[0].rate == @source1_rates[0][:rate]
  end

  def test_does_not_find_missing_reference_rate
    repo = Effex::Repository.for(:reference_rate)
    refute Effex::ExchangeRate.at(Date.today,'GBP','BGN')
    refute Effex::ExchangeRate.at(Date.today,'BGN','USD')
    refute Effex::ExchangeRate.at(Date.tomorrow,'GBP','USD')
  end

  def test_finds_cross_rate
    repo = Effex::Repository.for(:reference_rate)
    rates = Effex::ExchangeRate.all_at(Date.today,'USD','JPY')
    assert rates.length == 1
    assert rates[0].date == @source1_rates[0][:date]
    assert rates[0].base_currency == "USD"
    assert rates[0].counter_currency == "JPY"
    assert rates[0].rate == 2.0 / 1.2345
  end

end

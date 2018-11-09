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
        rate: "1.2345"
      },
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "JPY",
        rate: "2.0"
      },
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "CZK",
        rate: "2.0"
      },
      {
        date: Date.tomorrow,
        base_currency: "GBP",
        counter_currency: "USD",
        rate: "2.3456"
      }
    ]

    @source2_rates = [
      {
        date: Date.tomorrow,
        base_currency: "GBP",
        counter_currency: "JPY",
        rate: "2.0"
      }
    ]

    source1 = Effex::Source::Test.new("source1", @source1_rates)
    source2 = Effex::Source::Test.new("source2", @source2_rates)

    repo = Effex::Repository::Memory.new
    Effex::Repository.register(:rate, repo)

    Effex::ExchangeRate.load(source1)
    Effex::ExchangeRate.load(source2)
  end

  def teardown
    Timecop.return
  end

  def test_finds_rate
    repo = Effex::Repository.for(:rate)
    rates = Effex::ExchangeRate.all_at(Date.today,'GBP','USD')
    assert rates.length == 1
    assert rates[0].date == @source1_rates[0][:date]
    assert rates[0].base_currency == @source1_rates[0][:base_currency]
    assert rates[0].counter_currency == @source1_rates[0][:counter_currency]
    assert rates[0].rate == @source1_rates[0][:rate]
  end

  def test_does_not_find_missing_rate
    repo = Effex::Repository.for(:rate)

    # These rates weren't provided
    refute Effex::ExchangeRate.at(Date.today,'GBP','BGN')
    refute Effex::ExchangeRate.at(Date.today,'BGN','USD')

    # This is the wrong date
    refute Effex::ExchangeRate.at(Date.tomorrow,'GBP','CZK')
  end

  def test_finds_cross_rate
    repo = Effex::Repository.for(:rate)
    rates = Effex::ExchangeRate.all_at(Date.today,'USD','JPY')
    assert rates.length == 1
    assert rates[0].date == @source1_rates[0][:date]
    assert rates[0].base_currency == "USD"
    assert rates[0].counter_currency == "JPY"
    assert rates[0].rate == "%.3f" % (2.0 / 1.2345)
  end

  def test_does_not_find_missing_cross_rate
    repo = Effex::Repository.for(:rate)

    # This would need rates from different sources
    refute Effex::ExchangeRate.at(Date.tomorrow,'USD','JPY')
  end

  def test_can_find_multiple_rates
    duplicate_rates = [
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "USD",
        rate: "2.345"
      },
      {
        date: Date.today,
        base_currency: "GBP",
        counter_currency: "JPY",
        rate: "4.0"
      }
    ]

    source1 = Effex::Source::Test.new("source1", duplicate_rates)
    source2 = Effex::Source::Test.new("source2", duplicate_rates)

    repo = Effex::Repository::Memory.new
    Effex::Repository.register(:rate, repo)

    Effex::ExchangeRate.load(source1)
    Effex::ExchangeRate.load(source2)
    repo = Effex::Repository.for(:rate)

    # rates
    assert Effex::ExchangeRate.all_at(Date.today,'USD','JPY').length == 2
    assert Effex::ExchangeRate.all_at(Date.today,'USD','JPY').length == 2
  end
end

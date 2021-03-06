require "test_helper"
require 'timecop'

require 'effex/rate'

class RateCrossTest < Minitest::Test
  def setup
    Timecop.freeze

    @rate1 = {
      source: "source1",
      date: Date.today,
      base_currency: "USD",
      counter_currency: "GBP",
      rate: "1.123"
    }

    @rate2 = {
      source: "source1",
      date: Date.today,
      base_currency: "USD",
      counter_currency: "JPY",
      rate: "2.234"
    }

    @crossed_rate_str = "%.3f" % (2.234 / 1.123)
  end

  def teardown
    Timecop.return
  end

  def test_crosses_rates
    cross_rate = Effex::Rate::Cross.new(
      Effex::Rate::Rate.new(@rate1),
      Effex::Rate::Rate.new(@rate2)
    )

    assert cross_rate.is_a?(Effex::Rate::Cross)
    assert cross_rate.valid?
    assert cross_rate.date == @rate1[:date]
    assert cross_rate.base_currency == @rate1[:counter_currency]
    assert cross_rate.counter_currency == @rate2[:counter_currency]
    assert cross_rate.rate == @crossed_rate_str
  end

  def test_will_not_cross_with_different_source
      refute Effex::Rate::Cross.new(
        Effex::Rate::Rate.new(@rate1),
        Effex::Rate::Rate.new(@rate2.merge({source: "source2"}))
      ).valid?
  end

  def test_will_not_cross_with_different_date
      refute Effex::Rate::Cross.new(
        Effex::Rate::Rate.new(@rate1),
        Effex::Rate::Rate.new(@rate2.merge({date: Date.tomorrow}))
      ).valid?
  end

  def test_will_not_cross_with_different_base_currency
      refute Effex::Rate::Cross.new(
        Effex::Rate::Rate.new(@rate1),
        Effex::Rate::Rate.new(@rate2.merge({base_currency: "BGN"}))
      ).valid?
  end

  def test_will_not_cross_with_same_counter_currency
      refute Effex::Rate::Cross.new(
        Effex::Rate::Rate.new(@rate1),
        Effex::Rate::Rate.new(@rate2.merge({counter_currency: "GBP"}))
      ).valid?
  end
end

require "test_helper"
require "active_support/core_ext/hash/except"
require 'timecop'

require 'effex/rate'

class RateTest < Minitest::Test
  def setup
    Timecop.freeze

    @valid_rate = {
      source: "source1",
      date: Date.today,
      base_currency: "USD",
      counter_currency: "GBP",
      rate: "1.234"
    }
  end

  def teardown
    Timecop.return
  end

  def test_creates
    assert Effex::Rate::Rate.new(@valid_rate).valid?
  end

  def test_validates_source_format
    refute Effex::Rate::Rate.new(@valid_rate.merge(source: 1)).valid?
  end

  def test_validates_date
    assert Effex::Rate::Rate.new(@valid_rate.merge({date: "2018-10-10"})).valid?

    refute Effex::Rate::Rate.new(@valid_rate.except(:date)).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({date: "100-51515-0"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({date: "boo"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({date: {}})).valid?
  end

  def test_validates_base_currency
    refute Effex::Rate::Rate.new(@valid_rate.except(:base_currency)).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({base_currency: "boo"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({base_currency: "usd"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({base_currency: "us"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({base_currency: {}})).valid?
  end

  def test_validates_counter_currency
    refute Effex::Rate::Rate.new(@valid_rate.except(:counter_currency)).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({counter_currency: "boo"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({counter_currency: "gbp"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({counter_currency: "gb"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({counter_currency: {}})).valid?
  end

  def test_validates_currencies
    refute Effex::Rate::Rate.new(@valid_rate.merge({counter_currency: "USD"})).valid?
  end

  def test_validates_rate
    assert Effex::Rate::Rate.new(@valid_rate.merge({rate: "0.001"})).valid?
    assert Effex::Rate::Rate.new(@valid_rate.merge({rate: "123456.78"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({rate: "-123456.78"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({rate: "boo"})).valid?
    refute Effex::Rate::Rate.new(@valid_rate.merge({rate: {}})).valid?
  end

  def test_provides_numerical_rate
    assert Effex::Rate::Rate.new(@valid_rate).rate_f == 1.234
  end
end


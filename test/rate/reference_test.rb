require "test_helper"
require 'effex/rate/reference'
require "active_support/core_ext/hash/except"

class RateReferenceTest < Minitest::Test
  @@valid_rate = {
    date: Date.today,
    base_currency: "USD",
    counter_currency: "GBP",
    rate: 1.000
  }

  def test_creates
    assert Effex::Rate::Reference.new(@@valid_rate).valid?
  end

  def test_validates_date
    assert Effex::Rate::Reference.new(@@valid_rate.merge({date: "2018-10-10"})).valid?

    refute Effex::Rate::Reference.new(@@valid_rate.except(:date)).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({date: "100-51515-0"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({date: "boo"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({date: {}})).valid?
  end

  def test_validates_base_currency
    refute Effex::Rate::Reference.new(@@valid_rate.except(:base_currency)).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({base_currency: "boo"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({base_currency: "usd"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({base_currency: "us"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({base_currency: {}})).valid?
  end

  def test_validates_counter_currency
    refute Effex::Rate::Reference.new(@@valid_rate.except(:counter_currency)).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({counter_currency: "boo"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({counter_currency: "gbp"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({counter_currency: "gb"})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({counter_currency: {}})).valid?
  end

  def test_validates_currencies
    refute Effex::Rate::Reference.new(@@valid_rate.merge({counter_currency: "USD"})).valid?
  end

  def test_validates_rate
    assert Effex::Rate::Reference.new(@@valid_rate.merge({rate: 0.001})).valid?
    assert Effex::Rate::Reference.new(@@valid_rate.merge({rate: 123456.78})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({rate: -123456.78})).valid?
    refute Effex::Rate::Reference.new(@@valid_rate.merge({rate: "boo"})).valid?
  end
end


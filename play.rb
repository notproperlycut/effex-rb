require 'effex'

#repo = Effex::Repository::Memory.new
repo = Effex::Repository::Sequel.new
Effex::Repository.register(:reference_rate, repo)

source = Effex::Source::Ecb90Day.new()
Effex::ExchangeRate.load(source)
#Effex::ExchangeRate.load(source)

puts Effex::ExchangeRate.all_at(Date.parse("2018-11-01"),'USD','JPY')

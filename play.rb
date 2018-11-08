require 'effex'

repo = Effex::Repository::SQL.new
Effex::Repository.register(:reference_rate, repo)
puts Effex::ExchangeRate.all_at(Date.parse("2018-11-01"),'USD','JPY')

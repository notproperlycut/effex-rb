namespace :effex do
  desc "Fetch rates"

  task :fetch do |t, args|
    require "effex"

    repo = Effex::Repository::SQL.new
    Effex::Repository.register(:reference_rate, repo)

    source = Effex::Source::Ecb90Day.new()
    Effex::ExchangeRate.load(source)
  end
end


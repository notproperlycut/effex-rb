namespace :effex do
  desc "Fetch rates"

  task :fetch do |t, args|
    require "effex"

    repo = Effex::Repository::SQL.new(ENV.fetch("EFFEX_DB_URL"))
    Effex::Repository.register(:reference_rate, repo)

    source = Effex::Source::EcbXml.new(ENV.fetch("EFFEX_ECB_URLS"))
    Effex::ExchangeRate.load(source)
  end
end


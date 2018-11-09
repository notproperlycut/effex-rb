namespace :effex do
  desc "Request a rate"

  task :rate do |t, args|
    require "effex"

    # https://cobwwweb.com/4-ways-to-pass-arguments-to-a-rake-task
    ARGV.each { |a| task a.to_sym do ; end }

    repo = Effex::Repository::SQL.new(ENV.fetch("EFFEX_DB_URL"))
    Effex::Repository.register(:rate, repo)

    puts Effex::ExchangeRate.all_at(Date.parse(ARGV[1]), ARGV[2], ARGV[3])
  end
end

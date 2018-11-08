# https://github.com/jeremyevans/sequel/blob/master/doc/migration.rdoc

namespace :effex do
  desc "Run migrations"

  task :migrate do |t, args|
    require "sequel/core"
    Sequel.extension :migration

    Sequel.connect(ENV.fetch("EFFEX_DB_URL")) do |db|
      path = File.expand_path(__dir__)
      Sequel::Migrator.run(db, "#{path}/../../repository/migrations")
    end
  end
end

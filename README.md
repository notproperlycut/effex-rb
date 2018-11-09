# Effex

My notes on the implementation (and remaining steps to "production ready") are in [NOTES.md](NOTES.md)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'effex'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install effex

## Run tests
```
bundle
bundle exec rake test
```

## Usage
### Via the APIs
1. Register a repository under the `:rate` key. For example:
```
db_connection_string = "postgres://postgres:postgres@localhost:5432/postgres"
repo = Effex::Repository::SQL.new(db_connection_string)
Effex::Repository.register(:rate, repo)
```

2. Create and load a data source. For example:
```
source = Effex::Source::EcbXml.new("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml")
Effex::ExchangeRate.load(source)
```

3. Query for stored rates. For example:
```
Effex::ExchangeRate.all_at(Date.yesterday, "USD", "JPY") # rates from all sources
Effex::ExchangeRate.at(Date.yesterday, "USD", "JPY")     # only one rate
```

### Via the rake tasks
Include the Rakefile in your own if you wish, to gain three tasks:
- `rake effex:migrate` to migrate your chosen data store (required)
- `rake effex:fetch` to fetch and store from your chosen data sources. Fetch regularly on a suitable schedule.
- `rake effex:rate YYYY-MM-DD BASE COUNTER` to query rates (or cross rates) from your store

Example, `rake effex:rate 2018-10-10 USB GBP`

To use the above you *must* set two environment variables:
- `EFFEX_DB_URL` is a sequel-compatible database connection URL. See [here](http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html)
- `EFFEX_ECB_URLS` is a comma-separated list of URLs supplying ECB rates encoded in XML. See "Time Series" [here](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html)

### Via this repo
A short script is provided at `./example` to illustrate use of the rake tasks. To use:
```
bundle
bundle exec bash example
```

### Use with postgres
The `./example` script uses sqlite3 stored in a local `./rates.db` file. To test using postgres, the following should work

1. Start postgres locally. For example:
```
docker run --name pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

2. Use the correct sequel connection string:
```
export EFFEX_DB_URL="postgres://postgres:postgres@localhost:5432/postgres"
export EFFEX_ECB_URLS="http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"
```

3. Migrate
```
rake effex:migrate
```

4. Fetch and query
```
rake effex:fetch
rake effex:rate 2018-11-08 USD JPY
```

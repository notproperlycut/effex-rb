Sequel.migration do
  change do
    create_table :rates do
      primary_key :id
      String :source
      String :base_currency
      String :counter_currency
      Date   :date
      String :rate

      index [:date, :base_currency, :counter_currency]
      unique [:source, :base_currency, :counter_currency, :date]
    end
  end
end


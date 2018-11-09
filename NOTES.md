# TODO
This is not yet production-ready.

## Documentation
Documentation is sketchy. I've documented:
- the initializers of the two main classes of the domain model (`Effex::Rate::Rate` and `Effex::Rate::Cross`)
- the base classes for `Effex::Repository` and `Effex::Source` that document contracts for concrete implementations
- the entrypoint functions in `Effex::ExchangeRate`

## Testing
Test coverage is low:
- the domain model classes have unit tests
- the entrypoint methods have tests that use dummy source data and an in-memory repository
- the repository classes are not tested
- the source classes are not tested

I should write a suite of acceptance tests for concrete `Effex::Repository` implementations. For intance,
repositories must not duplicate rates that are presented more than once to `save()`

## Logging and metrics
Logging is inconsistent (and the configurability of logging is basic).

I'd probably want to instrument the code to (optionally) provide metrics, in a production setting.

# Style
My ruby is a little rusty (syntax, style, idioms)

My domain expertise is poor and I've likely mis-used some names (rate, quote, etc)

# Design
The library requested, seemed very much to live in its own bounded context. In a "simplest thing that will work"
style, there seemed no need to couple this gem to a framework that's geared to providing UI/API like Rails. Rather,
I wanted something that would emded easily wherever it is needed.  I did use a little of activemodel (because its
validation support is familiar to me)

## Data sources
The `Effex::Source::EcbXml` class supports multiple ECB feeds as long as they adhere to the same schema.

Other sources will need a new concrete implementation of `Effex::Source::Base`.

## Persistence
To keep things simple, I've chosen to use the repository pattern to structure the persistence-related code. I
had originally assumed I'd use ActiveRecord to build the SQL repository. I opted for sequel in the end, because the
required repository API (at this time) is so simple.

In principle, another `Effex::Repository` implementation could add support for a high-volume, high-datarate database
like BigTable. Regardless, the repository pattern helps to keep the implementation of persistence separate from
domain/business logic.

It feels like I could explore separating the persistence modules into other gems. For instance, I have already added
dependencies on `pg` and `sqlite3` gems, because those are what I used for testing. If we were to add support for
MySQL also, we would be polluting this gem's dependencies still further.

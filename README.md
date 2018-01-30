# Doorkeeper MongoDB extension
[![Build Status](https://travis-ci.org/doorkeeper-gem/doorkeeper-mongodb.svg?branch=master)](https://travis-ci.org/doorkeeper-gem/doorkeeper-mongodb)

## Installation

doorkeeper-mongodb provides Doorkeeper support to [MongoMapper](https://github.com/mongomapper/mongomapper) and
[Mongoid](https://github.com/mongodb/mongoid) (2, 3, 4 and 5 for doorkeeper-mongodb `3.0` and 4—6 for version `4.0`).
To start using it, add to your Gemfile:

``` ruby
gem "doorkeeper-mongodb", github: "doorkeeper-gem/doorkeeper-mongodb"
```

Run [doorkeeper’s installation generator]:

    rails generate doorkeeper:install

[doorkeeper’s installation generator]: https://github.com/doorkeeper-gem/doorkeeper#installation

This will install the doorkeeper initializer into
`config/initializers/doorkeeper.rb`.

Set the ORM configuration:

``` ruby
Doorkeeper.configure do
  orm :mongoid6 # or :mongoid4, :mongoid5, :mongo_mapper
end
```

## MongoMapper

**NOTE**: `mongo_mapper` gem works properly with MongoDB <= 3.2, on older versions it throws
`Database command 'insert' failed: Unknown option to insert command: w` exception. This problem
requires `mongo_mapper` gem update.

Also if you want to use `mongo_mapper` with Rails >= 5.0, then you need to add `activemodel-serializers-xml` gem
to your `Gemfile` (or `gems.rb`):

```ruby
gem 'activemodel-serializers-xml'
```

## Indexes

### Mongoid

Make sure you create indexes for doorkeeper models. You can do this either by
running `rake db:mongoid:create_indexes` or (if you're using Mongoid 2) by
adding `autocreate_indexes: true` to your `config/mongoid.yml`


### MongoMapper

Generate the `db/indexes.rb` file and create indexes for the doorkeeper models:

    rails generate doorkeeper:mongo_mapper:indexes
    rake db:index

## Tests

To run tests, clone this repository and run `rake`. It will copy and run
doorkeeper’s original test suite, after configuring the ORM according to the
variables defined in `.travis.yml` file.

To run locally, you need to choose a gemfile, with a command similar to:

```
$ export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile.mongoid6.rb
```

---

Please refer to https://github.com/doorkeeper-gem/doorkeeper for instructions on
doorkeeper’s project.

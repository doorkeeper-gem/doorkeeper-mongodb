# doorkeeper-mongodb extension

## Installation

doorkeeper-mongodb provides doorkeeper support to MongoMapper, Mongoid 2, 3 and 4.
To start using it, add to your Gemfile:

``` ruby
gem 'doorkeeper-mongodb'
```

Run [doorkeeper’s installation generator]:

    rails generate doorkeeper:install

[doorkeeper’s installation generator]: https://github.com/doorkeeper-gem/doorkeeper#installation

This will install the doorkeeper initializer into
`config/initializers/doorkeeper.rb`.

Set the ORM configuration:

``` ruby
Doorkeeper.configure do
  orm :mongoid2 # or :mongoid3, :mongoid4, :mongo_mapper
end
```

### Mongoid indexes

Make sure you create indexes for doorkeeper models. You can do this either by
running `rake db:mongoid:create_indexes` or (if you're using Mongoid 2) by
adding `autocreate_indexes: true` to your `config/mongoid.yml`


### MongoMapper indexes

Generate the `db/indexes.rb` file and create indexes for the doorkeeper models:

    rails generate doorkeeper:mongo_mapper:indexes
    rake db:index


## Tests

To run tests, clone this repository and run `rake`. It will copy and run
doorkeeper’s original test suite, after configuring the ORM according to the
variables defined in `.travis.yml` file.

To run locally, you need to choose a gemfile, with a command similar to:

```
$ export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile.mongoid4.rb
```

---

Please refer to https://github.com/doorkeeper-gem/doorkeeper for instructions on
doorkeeper’s project.

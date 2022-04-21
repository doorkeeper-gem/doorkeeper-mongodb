# Doorkeeper MongoDB extension
[![Gem Version](https://badge.fury.io/rb/doorkeeper-mongodb.svg)](https://badge.fury.io/rb/doorkeeper-mongodb)
[![Build Status](https://travis-ci.org/doorkeeper-gem/doorkeeper-mongodb.svg?branch=master)](https://travis-ci.org/doorkeeper-gem/doorkeeper-mongodb)

## Documentation

This documentation is valid for `master` branch. Please check the documentation for the version
of doorkeeper-mongodb you are using in: https://github.com/doorkeeper-gem/doorkeeper-mongodb/releases.

## Installation

`doorkeeper-mongodb` provides [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) support
for [Mongoid](https://github.com/mongodb/mongoid) versions 4, 5, 6 and 7. Earlier versions of Mongoid are supported
on `doorkeeper-mongodb` version 3.0.

To start using it, add to your Gemfile:

``` ruby
# For Doorkeeper >= 5.2
gem 'doorkeeper', '~> 5.2'
gem 'doorkeeper-mongodb', '~> 5.2'

# For Doorkeeper >= 5.0
gem 'doorkeeper', '~> 5.0'
gem 'doorkeeper-mongodb', '~> 5.0'

# For Doorkeeper >= 4.4 && < 5.0
gem 'doorkeeper', '~> 4.4'
gem 'doorkeeper-mongodb', '~> 4.2'

# For Doorkeeper < 4.4
gem 'doorkeeper', '~> 4.3'
gem 'doorkeeper-mongodb', '~> 4.1.0'

# or if you want to use cutting edge version:
# gem 'doorkeeper-mongodb', github: 'doorkeeper-gem/doorkeeper-mongodb'
```

Run [doorkeeper’s installation generator]:

    rails generate doorkeeper:install

[doorkeeper’s installation generator]: https://github.com/doorkeeper-gem/doorkeeper#installation

This will install the doorkeeper initializer into
`config/initializers/doorkeeper.rb`.

Set the ORM configuration:

``` ruby
Doorkeeper.configure do
  orm :mongoid7 # or any other version of mongoid
end
```

## Indexes

Make sure you create indexes for doorkeeper models. You can do this either by
running `rake db:mongoid:create_indexes` or (if you're using Mongoid 2) by
adding `autocreate_indexes: true` to your `config/mongoid.yml`

## Tests

To run tests, clone this repository and run `rake`. It will copy and run
doorkeeper’s original test suite, after configuring the ORM according to the
variables defined in `.travis.yml` file.

To run locally, you need to choose a gemfile, with a command similar to:

```
$ export RAILS=5.1
$ export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile.mongoid6.rb
```

---

Please refer to https://github.com/doorkeeper-gem/doorkeeper for instructions on
doorkeeper’s project.

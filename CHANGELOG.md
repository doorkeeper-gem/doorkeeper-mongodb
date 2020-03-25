# Changelog

User-visible changes worth mentioning.

## master

- [#] Your description here

## 5.2.0

- [#42] Add support for Doorkeeper >= 5.2

## 5.0.0

- [#36] Fix ownership concern to be Mongodb specific
- [#34] Fixes to support Doorkeeper >= 5.0

## 4.2.0

- [#32] Add `confidential` field for Doorkeeper >= 4.4
- [#35] Fixes to support Doorkeeper >= 4.4

## 4.1.0

- Update to upstream doorkeeper
- Fix mixins Access Token value generation to properly process custom
  token generator class methods
- Lazy load ORM models using ActiveSupport hooks
- Clear code base from the dead code
- Refactor mixins

## 4.0.1

- Code refactoring
- [#26] Lazy ORM models loading
- [#28] Mongoid 6 and 7beta support
- Test against Rails 5.2
- Update to upstream of Doorkeeper

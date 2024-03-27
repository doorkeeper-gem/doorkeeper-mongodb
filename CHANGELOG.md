# Changelog

User-visible changes worth mentioning.

## main

- Add your contribution here.

## 5.4.0

- [#89] Support custom attributes for Access Grant / Access Token.
- [#89] Upgrade Doorkeeper version, fix issues.
- [#87] Fix `matching_token_for`, enable to reuse_access_token.

## 5.3.0

- [#84] Add Mongoid8

## 5.2.2

- Fixes CVE-2020-10187
- [#62] Revoke `old_refresh_token` if `previous_refresh_token` is present.

## 5.2.1

- [#43] Fix issue with polymorphic resource owner

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

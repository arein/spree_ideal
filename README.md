# SpreeIdeal

Extends Spree for supporting [iDEAL payment](https://www.ideal.nl/en/) with  [ABN AMRO Internetkassa](https://internetkassa.abnamro.nl).

## Installation

Add spree_ideal to your Gemfile:

```ruby
gem 'spree_ideal', :git => 'git://github.com/arein/spree_ideal.git'
```

For a specific version use the appropriate branch, for example

```ruby
gem 'spree_ideal', :git => 'git://github.com/arein/spree_ideal.git', :branch => '2-4-stable'
```

Bundle your dependencies and run the installation generator:

```bash
bundle
bundle exec rails g spree_ideal:install
```

## Setup

Navigate to Spree Backend/Configuration/Payment Methods and add a new payment method with Provider "Spree::PaymentMethod::Ideal".

Then log into either your testing or production [ABN AMRO Internetkassa Back Office here](https://internetkassa.abnamro.nl).

Edit the following fields according to this doc:

* ABN URL: https://internetkassa.abnamro.nl/ncol/test/orderstandard.asp for testing or https://internetkassa.abnamro.nl/ncol/prod/orderstandard.asp for production
* PSPID: You'll find the PSPID in the fotter of the Back Office
* Accept URL: shop base url /ideal/accept
* Decline URL: shop base url /ideal/decline
* Exception URL: shop base url /ideal/exception
* Cancel URL: /ideal/cancel
* SHA IN Pass Phrase: Set this in the Back Office under Configuration -> Technical Information -> Data and Origin Verification -> SHA-IN Pass Phrase
* SHA Out Pass Phrase: Set this in the Back Office under Configuration -> Technical Information -> Transaction Feedback -> SHA-OUT Pass Phrase (may not equal the SHA-IN Pass Phrase)
* SHA Algorithm: Either "SHA-1", "SHA-256", or "SHA-512", according to the setting in the Back Office under Configuration -> Technical Information -> Global Security Parameters -> Hash Algorithm
* Shop Base URL: The shop base URL

__IMPORTANT:__In the backoffice you need to carry out a few actions:
* Set Configuration -> Technical Information -> Transaction Feedback -> "I would like to receive transaction feedback parameters on the redirection URLs" to YES
* Set Configuration -> Technical Information -> Transaction Feedback -> "Timing of the request" to "Always Deferred" and "Request Method" to "GET"
* Set Configuration -> Technical Information -> Transaction Feedback -> "Dynamic e-Commerce parameters" to "ACCEPTANCE", "AMOUNT", "BRAND", "CARDNO", "CURRENCY", "NCERROR", "ORDERID", "PAYID", "PM", "STATUS"

## Running the Tests

1. Install dependencies `bundle install`
2. Create a Dummy app `bundle exec rake test_app`
3. Change Directory `cd spec/dummy`
4. Create a Test Database `rake db:create RAILS_ENV=test`
5. Migrate `rake db:migrate RAILS_ENV=test`
6. Seed `bin/rake db:seed RAILS_ENV=test`
7. Load sample data `bin/rake spree_sample:load RAILS_ENV=test`
8. Change Directory `cd ../..`
9. Run RSpec `rspec spec`


## Acknowledgements

This repository is inspired by [@hefan's](https://github.com/hefan) [Spree Sofort Plugin](https://github.com/hefan/spree_sofort)

## License
released under the New BSD License

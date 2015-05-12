#!/bin/bash

bundle install
bundle exec rake test_app
cd spec/dummy
rake db:create RAILS_ENV=test
rake db:migrate RAILS_ENV=test
bin/rake db:seed RAILS_ENV=test
bin/rake spree_sample:load RAILS_ENV=test
cd ../..

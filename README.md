Todo backend
================

### Setup on Ubuntu 14.04
~~~
apt-get install ruby
apt-get install bundler
apt-get install zlib1g-dev
apt-get install libsqlite3-dev
bundle install
bundle exec rake db:migrate
ruby app.rb -o 0.0.0.0
~~~

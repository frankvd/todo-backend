Todo backend
================
*Frontend: https://github.com/Vrenc/todo-frontend*

### Setup on Ubuntu 14.04
~~~
apt-get install ruby
apt-get install bundler
apt-get install zlib1g-dev
apt-get install libsqlite3-dev
bundle install
bundle exec rake db:migrate
host=http://localhost:8888 port=8888 ruby app.rb -o 0.0.0.0
~~~

### Running tests
Before running `cucumber` to execute the tests, migrate the testing database with the following command: `bundle exec rake db:migrate db=testing.sqlite3`

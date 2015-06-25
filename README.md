##Setup
1. create a database:
 - `cat db/reset_database.sql | mysql -u root`
1. load sample data
 - `mysql -h [HOST] -u [USER] water_sample < db/water_sample_schema.sql`
1. install dependencies
 - `bundle install`
1. run specs
 - `bundle exec rspec spec`

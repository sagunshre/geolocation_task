# README

# Setup

1. Make a copy of .env_example and rename it to .env
2. Add ipstack access key to .env file
3. Build Services using docker compose
  ``docker-compose build``
4.  Create and Migrate Databases
  ``docker-compose run --rm web rails db:create``
  ``docker-compose run --rm web rails db:migrate``
5.  Run Rspec test
  ``docker-compose run web rspec``
6. Create and start containers
  ``docker-compose up``
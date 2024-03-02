# README

Started by [SulmanWeb](https://github.com/sulmanweb) on 2024-03-02.

## Development:

- Install Docker in the system.
- Run the following command to start the development server:
  ```bash
  docker-compose up -d --build
  ```
- Open the browser and go to `http://localhost:3000/up` to see the app running.
- Run the following command to setup the database:
  ```bash
  docker-compose run --rm api rails db:drop db:create db:migrate db:seed
  ```
- Run the following command to stop the development server:
  ```bash
  docker-compose down
  ```

## Testing:

- Run the following command to run RSpec tests:
  ```bash
  docker-compose run -e RAILS_ENV=test --rm api bundle exec rspec
  ```
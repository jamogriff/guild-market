# Guild Market

## Background and Description

Guild Market is a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices. This was a group project at the Turing School of Software and Design that was built over the course of a week.

## Learning Goals
- Practice designing a normalized database schema and defining model relationships
- Utilize advanced routing techniques including namespacing to organize and group like functionality together.
- Utilize advanced active record techniques to perform complex database queries
- Practice consuming a public API while utilizing POROs as a way to apply OOP principles to organize code

## Requirements
- must use Rails 5.2.x
- must use PostgreSQL
- all code must be tested via feature tests and model tests, respectively
- must use GitHub branching, team code reviews via GitHub comments, and github projects to track progress on user stories
- must include a thorough README to describe the project
- must deploy completed code to Heroku

## Setup

This project requires Ruby 2.7.2.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rake load_csv``
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

#### A Note on Using Existing Data

This project comes preloaded with customer, invoice, merchant, item and transaction data to pre-populate the application. The full data-set can be found in csv files under `app/db/data`. Additionally there is a collection of truncated data that is a lot easier to load and utilize that can be found at `app/db/data/test_data`. 
After running `bundle install`, either `rake load_csv` or `rake load_test_csv` should be run. The rake files will create the database, apply migrations and then load csv data into your database.

## Testing

Our project fully utilizes the test database of the Rails application to streamline testing. From the command-line, run `rake load_test_csv RAILS_ENV=test` to populate the test database. Our project uses RSpec as the testing framework, and individual items from the database can be tested by finding them using methods like `#first`, `#last` or `#find()`. Example in a before each hook:
```
before :each do
  @customer = Customer.first
  @customer_invoice = @customer.invoices.first
  @invoice_transaction = @customer_invoice.transaction.first
end
```	

## Schema

As mentioned above this applications handles inter-related data across customers, invoices, merchants and their items. This web of relationships is captured by the database schema used below:

<img src='/storage/schema.png'>
**Note**: Some small details like status columns have been changed to utilize enums for database efficiency. For the most up-to-date resource for this applications schema please see `db/schema.rb` after running your migrations.

## Phases

1. [Database Setup](./doc/db_setup.md)
1. [User Stories](./doc/user_stories.md)
1. [Extensions](./doc/extensions.md)
1. [Evaluation](./doc/evaluation.md)

# Ticketing System

A web-based application designed to manage and track tickets for various issues and tasks.

## Features

- **User Authentication:** Secure sign-up and login functionality.
- **Ticket Management:** Create, view, edit, and delete tickets.
- **Ticket Accountability:** Assign Support Agents to tickets for clear ownership of issues
- **Commenting System:** Add comments to tickets for collaborative discussions.
- **Status Tracking:** Assign and update ticket statuses to monitor progress.

## Built With

This project was developed using the following technologies:

* [Ruby on Rails](https://rubyonrails.org/) - Backend framework
* [SQLite3](https://www.sqlite.org/index.html) - Database

## Testing Stack

This project is tested with:

* [RSpec](https://rspec.info/) - Unit and integration testing
* [Capybara](https://teamcapybara.github.io/capybara/) - End-to-end testing
* [FactoryBot](https://github.com/thoughtbot/factory_bot) - Test data setup
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) - Simplifies model and controller tests

## Requirements

- See `.ruby-version` file for required Ruby version
- SQLite3 >3.45 (ideally, latest stable version)

## Installation

Follow these steps to set up the project locally:

1. **Clone the repository:**
    ``` bash
    git clone https://github.com/toby-d-parsons/ticketing-system.git
    cd ticketing-system
    ```
2. **Install required dependencies:**
    ``` bash
    bundle install
    ```
3. **Set up the database:**
    ``` bash
    rails db:setup && rails db:migrate
    ```

## Usage

1. **Start the Rails server:**
    ``` bash
    rails server
    ```
2. **Access the application:**

    Open your browser and go to http://localhost:3000

## Running Tests

To run the test suite and ensure the application works correctly, use:

``` bash
bundle exec rspec
```

## License

This project is licensed under the MIT License - see the `LICENSE.md` file for details
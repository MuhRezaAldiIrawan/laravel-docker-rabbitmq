# Copilot Instructions for Laravel Docker Project

## Overview
This project is a Laravel application running in a Docker environment. It utilizes PHP-FPM for processing PHP scripts and Vite for asset bundling and hot module replacement.

## Architecture
- **Services**: The application consists of multiple services defined in `docker-compose.yml`, including:
  - **app**: The main PHP-FPM service.
  - **db**: Database service (not detailed in the provided files).
  - **redis**: Caching service (not detailed in the provided files).

- **File Structure**: Key directories include:
  - `app/`: Contains the application logic, including controllers, models, and middleware.
  - `resources/`: Holds frontend assets like CSS and JavaScript.
  - `database/`: Contains migrations and seeders for database setup.

## Developer Workflows
- **Building the Application**: Use the command `docker-compose up --build` to build the application and its services.
- **Running the Application**: Start the application with `docker-compose up`.
- **Development Mode**: Use `npm run dev` to start Vite in development mode for hot reloading.
- **Production Build**: Run `npm run build` to create a production build of the assets.

## RabbitMQ & Queues 🔧
- RabbitMQ is provided in `docker-compose.yml` (service `rabbitmq`) and exposes ports `5672` (AMQP) and `15672` (management UI).
- To use RabbitMQ as the Laravel queue driver, install the community package: `composer require vladimir-yuldashev/laravel-queue-rabbitmq` and set `QUEUE_CONNECTION=rabbitmq` in `.env`.
- Recommended env variables to add to `.env`:
  - `QUEUE_CONNECTION=rabbitmq`
  - `RABBITMQ_HOST=rabbitmq`
  - `RABBITMQ_PORT=5672`
  - `RABBITMQ_USER=root`
  - `RABBITMQ_PASSWORD=root`
  - `RABBITMQ_QUEUE=default`
- Start a worker that consumes RabbitMQ jobs: `php artisan queue:work rabbitmq --queue=default --tries=3`.
- Example usage in this repository: `POST /api/products` creates a `Product` and dispatches `App\Jobs\ProcessProduct` to the `products` queue (see `app/Jobs/ProcessProduct.php`, `app/Http/Controllers/Api/ProductController.php`, `app/Models/Product.php`).

## Project Conventions
- **Environment Configuration**: Configuration files are located in the `config/` directory. Ensure to set up your `.env` file correctly for local development.
- **Database Migrations**: Use `php artisan migrate` to apply migrations. Seeders can be run with `php artisan db:seed`.

## Integration Points
- **Database**: The application connects to a database service defined in `docker-compose.yml`. Ensure the database service is running before starting the application.
- **Caching**: Redis is used for caching, which should also be defined in the `docker-compose.yml`.

## External Dependencies
- **PHP Extensions**: The Dockerfile installs necessary PHP extensions for the application to function correctly. Review the Dockerfile for any additional dependencies that may be required.
- **NPM Packages**: The project uses several NPM packages, including `axios` for making HTTP requests and `laravel-vite-plugin` for integrating Vite with Laravel.

## Key Files
- **Dockerfile**: Defines the PHP environment and dependencies.
- **docker-compose.yml**: Configures the services and their relationships.
- **vite.config.js**: Configures Vite for asset management.
- **package.json**: Lists project dependencies and scripts for building and running the application.

---

Please provide feedback on any unclear or incomplete sections to iterate further.

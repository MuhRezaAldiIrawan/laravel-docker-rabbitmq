FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies (including certs and AMQP build deps)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev \
    libxml2-dev \
    ca-certificates \
    openssl \
    libsasl2-dev \
    librabbitmq-dev \
    pkg-config

# Install PHP extensions
# Note: use "sockets" (not ext-sockets)
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip sockets

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install amqp extension for RabbitMQ (requires librabbitmq-dev)
RUN pecl install amqp && docker-php-ext-enable amqp

# Update CA certificates
RUN update-ca-certificates

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Change current user to www-data
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    build-essential \
    openssl

# Install PHP extensions
RUN docker-php-ext-install gd pdo pdo_mysql sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer.json and composer.lock to container
COPY composer.json ./

# Install dependencies via Composer
RUN composer install --optimize-autoloader --no-scripts

# Copy all files to container
COPY . .

RUN php artisan key:generate

# Perbaiki CMD untuk menjalankan beberapa perintah sekaligus
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8003"]

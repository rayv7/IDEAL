FROM php:8.2-apache

# Install system dependencies and PDO MySQL extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Copy local files to Apache web root
COPY . /var/www/html/

# Expose port 8080
EXPOSE 8080
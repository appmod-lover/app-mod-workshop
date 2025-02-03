# prova
# FL: https://docs.google.com/document/d/1NTrzZ63Mnmg91-l0W2Arp3TrY0cBhJaiBR_iGf6_5Dw/edit?tab=t.0
# bug: 
# trix: https://docs.google.com/spreadsheets/d/1K4XOx6tajw0T5jSaj-TMQJSiIb1zLhXDb1-zX5DaTOg/edit?resourcekey=0-wlbA5nZFAKIf1DnmWTYg1A&gid=0#gid=0
# code:  https://github.com/palladius/app-mod-workshop-set-by-step/blob/main/workshop-steps/20-dockerize/.solutions/dockerfile_php5.6_pdo/Dockerfile
# We try the 5.6 available from a colleague and then adapt to 5.7 :)



# Use the official PHP image.
# https://hub.docker.com/_/php
FROM php:5.6-apache

# Configure PHP for Cloud Run.
# Precompile PHP code with opcache.
# Install PHP's extension for MySQL
RUN docker-php-ext-install -j "$(nproc)" opcache mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
RUN set -ex; \
  { \
    echo "; Cloud Run enforces memory & timeouts"; \
    echo "memory_limit = -1"; \
    echo "max_execution_time = 0"; \
    echo "; File upload at Cloud Run network limit"; \
    echo "upload_max_filesize = 32M"; \
    echo "post_max_size = 32M"; \
    echo "; Configure Opcache for Containers"; \
    echo "opcache.enable = On"; \
    echo "opcache.validate_timestamps = Off"; \
    echo "; Configure Opcache Memory (Application-specific)"; \
    echo "opcache.memory_consumption = 32"; \
  } > "$PHP_INI_DIR/conf.d/cloud-run.ini"

# Copy in custom code from the host machine.
WORKDIR /var/www/html
# ./ /var/www/html
COPY . .

# Use the PORT environment variable in Apache configuration files.
# https://cloud.google.com/run/docs/reference/container-contract#port
# Setup the PORT variable
ENV PORT=8080
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

RUN ls -al "$PHP_INI_DIR/" # ricc being curious 

# Note: This is quite insecure and opens security breaches. See last chapter for hardening ideas.
RUN chmod 777 /var/www/html/uploads/

# Configure PHP for development.
# Switch to the production php.ini for production operations.
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# https://github.com/docker-library/docs/blob/master/php/README.md#configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Expose the port
EXPOSE 8080
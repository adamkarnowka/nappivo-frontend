# Use PHP-FPM as the base
FROM php:8.3-fpm-alpine

# Install nginx and supervisor to run multiple services in one container
RUN apk add --no-cache nginx supervisor bash \
    && mkdir -p /run/nginx /var/log/supervisor

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# App code
WORKDIR /var/www/html
COPY index.php ./

# Cloud Run expects the service to listen on $PORT. Default is 8080.
ENV PORT=8080
EXPOSE 8080

# Start supervisor which runs php-fpm and nginx in the foreground
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

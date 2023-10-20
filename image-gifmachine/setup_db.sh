#!/bin/bash

DB_HOST=$(echo $DATABASE_URL | awk -F'[@:]' '{print $4}')
DB_USER=$(echo $DATABASE_URL | awk -F'[:/@]' '{print $4}')
DB_PORT=$(echo $DATABASE_URL | awk -F'[:/]' '{print $(NF-1)}')
DB_NAME=$(echo $DATABASE_URL | awk -F'/' '{print $NF}')
DB_PASSWORD=$(echo $DATABASE_URL | awk -F'[:/@]' '{print $5}')

export PGPASSWORD=$DB_PASSWORD

echo "Check if the DB exists"
if psql -h $DB_HOST -U $DB_USER -p $DB_PORT -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "Database $DB_NAME already exists."
else
    echo "Creating the $DB_NAME database."
    bundle exec rake db:create
fi

echo "Running database migrations"
bundle exec rake db:migrate

# Clear the exporter password
unset PGPASSWORD

echo "Starting the app"
exec "$@"

# Use the official Ruby image as the base
FROM ruby:2.6.5

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock and install gems.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

# Now copy the rest of the application
COPY . .

# Expose the port the app runs on
EXPOSE 4567

RUN chmod +x /app/setup_db.sh

ENTRYPOINT ["/app/setup_db.sh"]
CMD ["ruby", "app.rb"]
# Use ruby image to build our own image
FROM ruby:2.7

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

# We specify everything will happen within the /app folder inside the container
WORKDIR /app
# We copy these files from our current application to the /app container
COPY Gemfile Gemfile.lock ./
# We install all the dependencies
RUN gem update bundler
RUN bundle install --jobs 5
# We copy all the files from our current application to the /app container
COPY . .
# We expose the port
EXPOSE 3000

RUN yarn install

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

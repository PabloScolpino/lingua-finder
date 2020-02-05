FROM ruby:2.4.4

# Update container and add dependencies
RUN apt-get update -y -qq && apt-get upgrade -y -qq && apt-get -y install curl gnupg -qq
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

# Create app user
RUN useradd -ms /bin/bash app --uid 1000
USER app

# Install the app
ADD --chown=app:app . /mnt/app
WORKDIR /mnt/app
RUN bundle install

ARG APP_ROOT=/app
ARG BUNDLE_PATH=/bundler
ARG RUBY_VERSION=2.5.9
ARG PACKAGES_RUNTIME="tzdata libpq5 nodejs"

################################################################################
# Base configuration
#
FROM ruby:$RUBY_VERSION-slim AS builder-base
ARG APP_ROOT
ARG PACKAGES_BUILD="build-essential libpq-dev nodejs yarn"
ARG BUNDLE_PATH

ENV BUNDLE_PATH=$BUNDLE_PATH
ENV BUNDLE_BIN="$BUNDLE_PATH/bin"

WORKDIR $APP_ROOT

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends $PACKAGES_BUILD
COPY Gemfile Gemfile.lock $APP_ROOT/

################################################################################
# Production builder stage
#
FROM builder-base AS production-builder

ENV BUNDLE_DEPLOYMENT=1
ENV BUNDLE_WITHOUT='development:test'
ENV RAILS_ENV=production

ENV SECRET_KEY_BASE=a-temporary-secret

RUN bundle install --jobs 4 --retry 3
COPY . $APP_ROOT/
RUN bundle exec rake assets:precompile

################################################################################
# Production image
#
# Same as the base for the base image
FROM ruby:$RUBY_VERSION-slim AS production
LABEL org.opencontainers.image.source https://github.com/pabloscolpino/lingua-finder
ARG APP_ROOT
ARG BUNDLE_PATH
ARG PACKAGES_RUNTIME

WORKDIR $APP_ROOT

ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV BUNDLE_DEPLOYMENT=1
ENV BUNDLE_PATH=$BUNDLE_PATH
ENV BUNDLE_WITHOUT='development:test'
ENV RAILS_ENV=production

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends $PACKAGES_RUNTIME

COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=production-builder $APP_ROOT $APP_ROOT

################################################################################
# Development image
#
FROM builder-base AS development
LABEL org.opencontainers.image.source https://github.com/pabloscolpino/lingua-finder
ARG PACKAGES_DEV="postgresql-client xvfb"
ARG PACKAGES_RUNTIME

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends $PACKAGES_DEV $PACKAGES_RUNTIME && \
    bundle install --jobs 4 --retry 3

ARG APP_ROOT=/app
ARG BUNDLE_PATH=/bundler
ARG RUBY_VERSION=2.5.9
ARG PACKAGES_RUNTIME="libpq tzdata nodejs"

################################################################################
# Base configuration
#
FROM ruby:$RUBY_VERSION-alpine AS builder-base
ARG APP_ROOT
ARG PACKAGES_BUILD="build-base ruby-dev postgresql-dev xz-libs tzdata nodejs"
ARG BUNDLE_PATH

ENV BUNDLE_PATH=$BUNDLE_PATH
ENV BUNDLE_BIN="$BUNDLE_PATH/bin"

WORKDIR $APP_ROOT

RUN apk add --update-cache $PACKAGES_BUILD && apk upgrade
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
FROM ruby:$RUBY_VERSION-alpine AS production
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

RUN apk add --update-cache $PACKAGES_RUNTIME

# Coping the generated artifacts and scrapping all the libs and binaries not necesary for execution
COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=production-builder $APP_ROOT $APP_ROOT

################################################################################
# Development image
#
FROM builder-base AS development
LABEL org.opencontainers.image.source https://github.com/pabloscolpino/lingua-finder
ARG PACKAGES_DEV="postgresql-client"
ARG PACKAGES_RUNTIME

RUN apk add --update-cache $PACKAGES_DEV $PACKAGES_RUNTIME && apk upgrade && \
    bundle install --jobs 4 --retry 3

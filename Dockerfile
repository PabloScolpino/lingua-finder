ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base ruby-dev postgresql-dev xz-libs tzdata nodejs"
ARG RUBY_VERSION=2.4.4
################################################################################
# Base configuration
#
FROM ruby:$RUBY_VERSION-alpine AS builder-base
ARG RAILS_ROOT
ARG BUILD_PACKAGES

WORKDIR $RAILS_ROOT
COPY . .
RUN apk add --update-cache $BUILD_PACKAGES

################################################################################
# Production builder stage
#
FROM builder-base AS production-builder
RUN bundle install --jobs 4 --retry 3 --deployment

################################################################################
# Production image
#
# Same as the base for the base image
FROM ruby:$RUBY_VERSION-alpine AS production
LABEL org.opencontainers.image.source https://github.com/pabloscolpino/lingua-finder
ENV RAILS_ENV=production
ARG RAILS_ROOT
# Coping the generated artifacts and scrapping all the libs and binaries not necesary for execution
COPY --from=production-builder $RAILS_ROOT $RAILS_ROOT

################################################################################
# Development image
#
FROM builder-base AS development
LABEL org.opencontainers.image.source https://github.com/pabloscolpino/lingua-finder
ARG DEV_PACKAGES="postgresql-client"
ARG RAILS_ROOT

ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"
ENV BUNDLE_PATH=/bundler
ENV BUNDLE_BIN="$BUNDLE_PATH/bin"
ENV PATH="$BUNDLE_BIN:$RAILS_ROOT/bin:$PATH"

RUN apk add --update-cache $DEV_PACKAGES && \
    bundle install --jobs 4 --retry 3

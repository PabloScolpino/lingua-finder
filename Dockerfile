FROM ruby:2.4.4

RUN apt-get update -y -qq && apt-get upgrade -y -qq && apt-get -y install curl gnupg -qq
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs

ADD . /mnt/app
WORKDIR /mnt/app
RUN bundle install

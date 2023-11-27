FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev git libpq-dev nodejs

RUN gem install bundler

COPY . /application

WORKDIR /application

COPY Gemfile /application/Gemfile
COPY Gemfile.lock /application/Gemfile.lock

RUN bundle install

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

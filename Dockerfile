FROM ruby:3.2.2

# Rails 7.2の標準に合わせる
WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install -y build-essential default-libmysqlclient-dev nodejs

COPY Gemfile /rails/Gemfile
COPY Gemfile.lock /rails/Gemfile.lock

RUN bundle install

COPY . /rails

# Rails 7.2が生成したスクリプトを利用
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
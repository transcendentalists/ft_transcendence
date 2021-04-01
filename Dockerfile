FROM ruby:2.7.1-alpine3.12
RUN apk add --update --no-cache \
        bash \
        build-base \
        nodejs \
        postgresql-dev \
        postgresql-client \
        libxslt-dev \
        libxml2-dev \
        tzdata \
        yarn    

RUN mkdir /project
WORKDIR /project

# Setup Gem Module
ENV BUNDLER_VERSION=2.2.2
RUN gem update --system
RUN gem install --default bundler -v 2.2.2

RUN if [ ! -d "./tmp" ] ; then mkdir "./tmp" && mkdir "./tmp/db" ; fi

COPY ./project/Gemfile ./project/Gemfile.lock ./
RUN bundle install

# Setup Node Module
ENV RAILS_ENV development
COPY ./project/package.json ./project/yarn.lock ./

# Copy Apllication Source
COPY ./project .

# Setup Entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

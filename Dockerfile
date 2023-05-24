FROM node:14.18.1-slim AS node

FROM ruby:3.0.2-slim

ARG YARN_VERSION

RUN mkdir -p /opt
COPY --from=node /opt/yarn-v${YARN_VERSION} /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx 
RUN apt-get update 
RUN apt-get install -y g++ make 
RUN apt-get install -y  libpq-dev 
RUN apt-get install -y postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock package.json /app/

RUN bundle install
RUN yarn

CMD ["rails", "s", "-b", "0.0.0.0"]
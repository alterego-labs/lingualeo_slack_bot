FROM elixir:1.3.2

MAINTAINER Sergey Gernyak <sergeg1990@gmail.com>

ARG SLACK_BOT_TOKEN

ENV MIX_ENV=prod
ENV SLACK_BOT_TOKEN ${SLACK_BOT_TOKEN}

RUN apt-get update && apt-get install -y build-essential git-core

RUN mkdir -p /app

WORKDIR /app

COPY . ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get && mix deps.compile
RUN mix compile
RUN mix release --verbosity=verbose

CMD ["rel/lingualeo_slack_bot/bin/lingualeo_slack_bot", "console"]

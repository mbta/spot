# Build stage
FROM hexpm/elixir:1.20.4-erlang-29.1-alpine-3.24.2 AS elixir
WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force


COPY . .
RUN mix deps.get

ENV MIX_ENV=prod

RUN mix compile
RUN mix release --path /app-release

# Runtime stage
FROM hexpm/elixir:1.20.4-erlang-29.1-alpine-3.24.2 as runtime

COPY --from=elixir /app-release .

HEALTHCHECK CMD ["bin/spot", "rpc", "Spot.Health.healthy?()"]
CMD ["bin/spot", "start"]

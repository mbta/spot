# Build stage
FROM hexpm/elixir:1.20.4-erlang-29.1.2-alpine-3.24.3 AS elixir
WORKDIR /app

RUN apk add --no-cache git && \
  mix local.hex --force && \
  mix local.rebar --force

COPY . .
# Private git dependency (subway_inputs): the token is read from a build secret and
# supplied through env-based git config so it is never written to the image
RUN --mount=type=secret,id=subway_inputs_token \
  GIT_CONFIG_COUNT=1 \
  GIT_CONFIG_KEY_0="url.https://x-access-token:$(cat /run/secrets/subway_inputs_token)@github.com/mbta/subway_inputs.insteadOf" \
  GIT_CONFIG_VALUE_0="https://github.com/mbta/subway_inputs" \
  mix deps.get

ENV MIX_ENV=prod

RUN mix compile
RUN mix release --path /app-release

# Runtime stage
FROM hexpm/elixir:1.20.4-erlang-29.1.2-alpine-3.24.3 as runtime

COPY --from=elixir /app-release .

HEALTHCHECK CMD ["bin/spot", "rpc", "Spot.Health.healthy?()"]
CMD ["bin/spot", "start"]

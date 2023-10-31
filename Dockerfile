FROM hexpm/elixir:1.14.4-erlang-25.3.2-ubuntu-focal-20230126

# Install debian packages
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y inotify-tools
RUN apt-get install -y postgresql-client 
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y ca-certificates gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=18
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

COPY . /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
COPY priv priv
COPY lib lib
COPY assets assets

CMD mix deps.get && \
    mix deps.compile && \
    mix ecto.create && \
    mix ecto.migrate && \
    npm install --prefix=assets && \
    mix phx.server

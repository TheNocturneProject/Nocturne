FROM amberframework/amber:v0.7.2

WORKDIR /app

COPY . /app

# Set up necessary ENV variables
# ENV AMBER_ENCRYPTION_KEY "$AMBER_ENCRYPTION_KEY"
# ENV AMBER_ENV "$PRODUCTION"

# Install deps
RUN shards install
RUN npm install

# Build the binary
RUN npm run release
RUN amber db create migrate
RUN shards build --production --release

CMD ["./bin/nocturne"]

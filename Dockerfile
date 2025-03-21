# https://github.com/jtagcat/dotfiles/blob/main/scripts/template/gobuild.Dockerfile
# non-working workarounds: https://gist.github.com/jtagcat/189b2fd239687ab700f54faa46907df4

FROM golang:1.23 AS builder
WORKDIR /wd

COPY go.mod go.sum ./
RUN go mod download

# https://github.com/docker/docker.github.io/issues/14609
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine
LABEL org.opencontainers.image.source="https://github.com/jtagcat/spotify-togit"
WORKDIR /wd
RUN apk add --no-cache git
RUN git config --global --add safe.directory '*'

COPY --from=builder /wd/app ./
CMD ["./app"]

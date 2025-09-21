FROM alpine:edge AS build
WORKDIR /root

RUN apk upgrade; \
    apk add go

RUN go env -w GOCACHE=/go-cache
RUN go env -w GOMODCACHE=/gomod-cache

COPY syne/go.mod ./
RUN --mount=type=cache,target=/gomod-cache \
  go mod download

COPY mnemo/go.mod ./
RUN --mount=type=cache,target=/gomod-cache \
  go mod download

COPY ./syne ./syne
RUN --mount=type=cache,target=/gomod-cache --mount=type=cache,target=/go-cache \
  go build -C syne -o ../out/ .

COPY ./mnemo ./mnemo
RUN --mount=type=cache,target=/gomod-cache --mount=type=cache,target=/go-cache \
  go build -C mnemo -o ../out/ .

FROM alpine:edge AS runner
WORKDIR /root

RUN apk upgrade; apk add curl zellij helix helix-tree-sitter-vendor

EXPOSE 8080

COPY docker/config.kdl /root/.config/zellij/config.kdl
COPY --from=build /root/out/* /root/

CMD ["/root/mnemo"]

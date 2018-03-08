FROM alpine:3.7 AS build

# avoid installing these packages twice
RUN apk add --update --no-cache glib libnotify && \
    rm -rf /var/cache/apk/*

RUN apk add --update --no-cache \
        gcc \
        git \
        glib-dev \
        go \
        libnotify-dev \
        make \
        musl-dev && \
    rm -rf /var/cache/apk/*

ENV GOPATH /go
ENV PATH "${PATH}:${GOPATH}/bin"
COPY . /go/src/github.com/marklee77/prom-alert-notifier
WORKDIR /go/src/github.com/marklee77/prom-alert-notifier
RUN make install

FROM alpine:3.7

RUN apk add --update --no-cache glib libnotify && \
    rm -rf /var/cache/apk/*

COPY --from=build /go/bin/prom-alert-notifier /go/bin/

CMD ["/go/bin/prom-alert-notifier"]
EXPOSE 8080

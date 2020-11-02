FROM debian:stable-slim AS certs

RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates

FROM golang:1.7.3 AS build

WORKDIR /
RUN go get github.com/coredns/records
RUN go generate
RUN go build

FROM scratch

COPY --from=certs /etc/ssl/certs /etc/ssl/certs
COPY --from=build /coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]

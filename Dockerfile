FROM golang:1.18.3 as builder

WORKDIR /go/src/github.com/prometheus/memcached_exporter

COPY . .
RUN go mod download
RUN make common-build

RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group

FROM scratch as scratch
COPY --from=builder /go/src/github.com/prometheus/memcached_exporter/memcached_exporter /bin/memcached_exporter
COPY --from=builder /user/group /user/passwd /etc/
COPY ./entrypoint.sh ./entrypoint.sh

EXPOSE      9150
USER        nobody
ENTRYPOINT  [ "./entrypoint.sh" ]

FROM quay.io/sysdig/sysdig-mini-ubi:1.3.7 as ubi
COPY --from=builder /go/src/github.com/prometheus/memcached_exporter/memcached_exporter /bin/memcached_exporter
COPY ./entrypoint.sh ./entrypoint.sh

USER       nobody
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE     9150

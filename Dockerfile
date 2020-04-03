# syntax = docker/dockerfile:1.0-experimental
FROM golang:1.13.9-alpine AS base

ARG PROJECT_NAME=Wr4thon/microServices
COPY . /go/src/github.com/fino/${PROJECT_NAME}
WORKDIR /go/src/github.com/fino/${PROJECT_NAME}

RUN apk --no-cache --update add git openssh-client ca-certificates &&\
    update-ca-certificates

ENV GO111MODULE on
ENV CGO_ENABLED 0
ENV GOOS linux 

RUN go mod download
RUN go get -u golang.org/x/lint/golint
RUN go get -u github.com/poy/onpar
RUN go get -u github.com/stretchr/testify/assert


# run lint and go vet
FROM base AS lint
RUN ./lint.sh


# run tests
FROM lint AS test
RUN go test ./...


# run bulid
FROM test as build
RUN go build -a -installsuffix cgo -o app ./cmd/main.go
RUN cp ./app /bin/


# for timezone stuff
FROM alpine:3.10.2 as timezone
RUN apk --no-cache add tzdata zip ca-certificates
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .


# final
FROM scratch AS service
EXPOSE 8080
ENTRYPOINT [ "/bin/app" ]
ENV ZONEINFO /zoneinfo.zip
ENV TZ Europe/Berlin
COPY --from=timezone /zoneinfo.zip /
COPY --from=timezone /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build bin/app /bin/app

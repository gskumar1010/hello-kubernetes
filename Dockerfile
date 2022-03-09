FROM golang:1.15.2-alpine3.12 AS builder
WORKDIR /build
RUN apk add --update --no-cache git ca-certificates build-base
RUN go get -u github.com/markbates/pkger/cmd/pkger
RUN pkger -h
COPY go.mod .
COPY go.sum .
RUN go mod download -x
COPY . .
RUN pkger
RUN go build -o main

FROM alpine:3.12
COPY --from=builder /build/main .
ENTRYPOINT [ "./main" ]

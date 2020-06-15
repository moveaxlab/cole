FROM golang:alpine AS build
COPY . /go/src/github.com/jpweber/cole

WORKDIR /go/src/github.com/jpweber/cole
RUN apk --update upgrade && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add git
RUN go get -d -v
RUN CGO_ENABLED=0 go build -a -ldflags '-s' -installsuffix cgo -o app .

# copy the binary from the build stage to the final stage
FROM alpine:3.8
RUN apk --update upgrade && \
    apk add ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
COPY --from=build /go/src/github.com/jpweber/cole/app /cole
CMD ["/cole"]
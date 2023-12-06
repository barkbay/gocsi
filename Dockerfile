FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.21 as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /app/
ADD . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /app/bin/csc csc/main.go

FROM --platform=${TARGETPLATFORM:-linux/amd64} bash
WORKDIR /app/
COPY --from=builder /app/bin/csc /usr/bin/csc
ENTRYPOINT ["/usr/bin/csc"]
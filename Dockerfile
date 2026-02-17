FROM golang:1.26-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

ARG TARGETOS
ARG TARGETARCH

COPY . .

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o fritzbox_smarthome_exporter .


FROM scratch

COPY passwd /etc/passwd
COPY --from=builder /build/fritzbox_smarthome_exporter /fritzbox_smarthome_exporter

EXPOSE 9103

USER 65534
ENTRYPOINT ["/fritzbox_smarthome_exporter"]

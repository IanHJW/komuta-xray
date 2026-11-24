FROM alpine:3.20 AS builder
ARG XRAY_VERSION=v26.11.9
RUN apk add --no-cache curl unzip ca-certificates \
 && curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" \
 && mkdir -p /tmp/xray && unzip -o /tmp/xray.zip -d /tmp/xray

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata
COPY --from=builder /tmp/xray/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /usr/local/bin/xray /entrypoint.sh
ENV PORT=3000
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]

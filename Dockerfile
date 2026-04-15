# czesc 1
FROM alpine:latest AS builder

ARG VERSION=1.0

RUN apk add --no-cache iproute2

# Generowanie index.html 
RUN echo "<html><body>" > index.html && \
    echo "<h1>Sprawozdanie</h1>" >> index.html && \
    echo "<p>IP: $(hostname -i)</p>" >> index.html && \
    echo "<p>Hostname: $(hostname)</p>" >> index.html && \
    echo "<p>Version: $VERSION</p>" >> index.html && \
    echo "</body></html>" >> index.html


# czesc2 
FROM nginx:latest

# Kopiowanie strony z etapu 1
COPY --from=builder index.html /usr/share/nginx/html/index.html

# Healthcheck
HEALTHCHECK CMD curl --fail http://localhost || exit 1

EXPOSE 80
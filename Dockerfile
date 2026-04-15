# czesc 1
FROM alpine:latest AS builder

ARG VERSION=1.0

WORKDIR /app

# template hmtl
RUN echo "<h1>Sprawozdanie 2</h1>" > index.template.html && \
    echo "<p>IP: {{IP}}</p>" >> index.template.html && \
    echo "<p>Hostname: {{HOST}}</p>" >> index.template.html && \
    echo "<p>Version: {{VERSION}}</p>" >> index.template.html


# czesc 2
FROM nginx:alpine

ARG VERSION=1.0
ENV VERSION=${VERSION}

# instalujemy curl 
RUN apk add --no-cache curl

# kopiujemy z templatki
COPY --from=builder /app/index.template.html /app/index.template.html

# skrypt startowy
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'IP=$(hostname -i)' >> /start.sh && \
    echo 'HOST=$(hostname)' >> /start.sh && \
    echo 'sed -e "s/{{IP}}/$IP/" -e "s/{{HOST}}/$HOST/" -e "s/{{VERSION}}/$VERSION/" /app/index.template.html > /usr/share/nginx/html/index.html' >> /start.sh && \
    echo 'nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 80

HEALTHCHECK CMD curl -f http://localhost/ || exit 1

CMD ["/start.sh"]S
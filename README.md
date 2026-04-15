
# Sprawozdanie-Pawcho-2


##  Opis projektu

Celem zadania było stworzenie obrazu Dockera z wykorzystaniem:

* budowania wieloetapowego (
* serwera nginx
* zmiennej `ARG VERSION`
* mechanizmu `HEALTHCHECK`

Strona internetowa generowana przez kontener wyświetla:

* adres IP kontenera
* nazwę hosta
* wersję aplikacji

---

##  Dockerfile

```dockerfile
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
```

---

##  Budowanie obrazu

```bash
docker build --build-arg VERSION=1.0 -t sprawozdanie2 .
```

---

##  Uruchomienie kontenera

```bash
docker run -d -p 8080:80 --name spr2 sprawozdanie2
```

---

##  Sprawdzenie działania

Strona dostępna w przeglądarce:

```
http://localhost:8080
```

---

##  Test za pomocą curl

```bash
curl http://localhost:8080
```

---

##  Sprawdzenie HEALTHCHECK

```bash
docker inspect --format='{{.State.Health.Status}}' spr2
```

Oczekiwany wynik:

```
healthy
```

---

##  Historia warstw obrazu

```bash
docker history sprawozdanie2
```
C:\Users\kemot\sprawozdanie2>docker history sprawozdanie2

| IMAGE        | CREATED        | CREATED BY                                                      | SIZE     | COMMENT                    |
|--------------|----------------|------------------------------------------------------------------|----------|----------------------------|
| bf1fe3181fd8 | 13 minutes ago | EXPOSE [80/tcp]                                                 | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 13 minutes ago | HEALTHCHECK CMD-SHELL curl --fail http...                      | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 13 minutes ago | COPY index.html /usr/share/nginx/html/index...                 | 24.6kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | CMD ["nginx" "-g" "daemon off;"]                               | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | STOPSIGNAL SIGQUIT                                              | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | EXPOSE map[80/tcp:{}]                                           | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENTRYPOINT ["/docker-entrypoint.sh"]                            | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | COPY 30-tune-worker-processes.sh /docker-entrypoint...         | 16.4kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | COPY 20-envsubst-on-templates.sh /docker-entrypoint...         | 12.3kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | COPY 15-local-resolvers.envsh /docker-entrypoint...            | 12.3kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | COPY 10-listen-on-ipv6-by-default.sh /docker-entrypoint...     | 12.3kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | COPY docker-entrypoint.sh /                                     | 8.19kB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | RUN set -x && groupadd --system ...                             | 86.7MB   | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV DYNPKG_RELEASE=1~trixie                                     | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV PKG_RELEASE=1~trixie                                        | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV ACME_VERSION=0.3.1                                          | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV NJS_RELEASE=1~trixie                                        | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV NJS_VERSION=0.9.6                                           | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | ENV NGINX_VERSION=1.29.6                                        | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 5 weeks ago    | LABEL maintainer=NGINX Docker Maintainers ...                   | 0B       | buildkit.dockerfile.v0     |
| <missing>    | 7 weeks ago    | debian.sh --arch 'amd64' out/ 'trixie' ...                      | 87.4MB   | debuerreotype 0.17         |
---


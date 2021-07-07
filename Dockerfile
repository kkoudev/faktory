FROM alpine:3.13

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

RUN apk add --no-cache redis ca-certificates socat
COPY ./faktory-amd64 /
COPY ./faktory-arm64 /

RUN mkdir -p /root/.faktory/db
RUN mkdir -p /var/lib/faktory/db
RUN mkdir -p /etc/faktory
RUN export USE_ARCH=$(echo -n ${TARGETPLATFORM} | sed -E 's;linux/;;g') \
  && mv faktory-${USE_ARCH} faktory \
  && rm -f faktory-*

EXPOSE 7419 7420
CMD ["/faktory", "-w", "0.0.0.0:7420", "-b", "0.0.0.0:7419"]

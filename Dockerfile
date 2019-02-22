##
# Name:		pressboxx/alpine-iso
# Build:	docker build --rm -t pressboxx/alpine-iso .
# Run:		docker run --rm -v `pwd`/iso/:/iso/ -t -i --privileged pressboxx/alpine-iso
##

FROM alpine:latest

LABEL maintainer="Mick Hellstrom, mick@newclarity.net" \
    decription="pressboxx" \
    version="${PRESSBOXX_VERSION}" \
    org.label-schema.name="pressboxx" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/pressboxx/pressboxx" \
    org.label-schema.schema-version="0.5.0-rc1"


COPY files/build /build

WORKDIR /build
ENV PROFILENAME base

RUN ls -l /build && /bin/sh /build/build-docker.sh

# ENTRYPOINT ["./build/build-iso.sh"]
CMD ["/build/build-iso.sh"]


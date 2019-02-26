##
# Name:		gearbox/alpine-iso
# Build:	docker build --rm -t gearbox/alpine-iso .
# Run:		docker run --rm -v `pwd`/iso/:/iso/ -t -i --privileged gearbox/alpine-iso
##

FROM alpine:latest

LABEL maintainer="Mick Hellstrom, mick@newclarity.net" \
    decription="gearbox" \
    version="${PRESSBOXX_VERSION}" \
    org.label-schema.name="gearbox" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/gearbox/iso-maker" \
    org.label-schema.schema-version="0.5.0-rc1"


COPY files/build /build

WORKDIR /build
ENV PROFILENAME base

RUN ls -l /build && /bin/sh /build/build-docker.sh

# ENTRYPOINT ["./build/build-iso.sh"]
CMD ["/build/build-iso.sh"]


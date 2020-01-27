##
# Name:		gearboxworks/alpine-iso
# Build:	docker build --rm -t gearboxworks/alpine-iso .
# Run:		docker run --rm -v `pwd`/iso/:/iso/ -t -i --privileged gearboxworks/alpine-iso
##

FROM alpine:latest

LABEL maintainer="Mick Hellstrom, mick@newclarity.net" \
    decription="Gearbox ISO maker" \
    version="${GEARBOX_VERSION}" \
    org.label-schema.name="gearbox" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/gearbox/iso-maker" \
    org.label-schema.schema-version="0.5.0-rc1"


COPY build /build

WORKDIR /build
ENV PROFILENAME base

RUN ls -l /build && /bin/sh /build/build-docker.sh

# ENTRYPOINT ["./build/build-iso.sh"]
CMD ["/bin/bash", "-l", "/build/build-iso.sh"]


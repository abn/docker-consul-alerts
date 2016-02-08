FROM fedora:latest
MAINTAINER Arun Neelicattu <arun.neelicattu@gmail.com>

RUN dnf -y upgrade

# install base requirements
RUN dnf -y install golang git hg 
RUN dnf -y install findutils

# prepare gopath
ENV GOPATH /go
ENV PATH /go/bin:${PATH}
RUN mkdir -p ${GOPATH}

ARG IMAGE
ARG PACKAGE
ARG VERSION
ARG BINARY

ENV IMAGE ${IMAGE}
ENV PACKAGE ${PACKAGE}
ENV VERSION ${VERSION}
ENV BINARY ${BINARY}
ENV GO_BUILD_TAGS netgo
ENV CGO_ENABLED 1

COPY ./loadbins /usr/bin/loadbins

RUN go get ${PACKAGE}

WORKDIR ${GOPATH}/src/${PACKAGE}
RUN git checkout -b v${VERSION} v${VERSION}

RUN mkdir bin
RUN go build \
        -tags "${GO_BUILD_TAGS}" \
        -ldflags "-s -w -X ${PACKAGE}/version.Version ${VERSION}" \
        -v -a \
        -installsuffix cgo \
        -o ./bin/${BINARY}

ENV ROOTFS rootfs

ENV DEST ${ROOTFS}
RUN loadbins ./bin/${BINARY}
RUN find ${ROOTFS} -name "*.so" -exec loadbins {} \;

RUN install -D ./bin/${BINARY} ${ROOTFS}/usr/bin/${BINARY}

# build image
COPY Dockerfile.final Dockerfile
CMD docker build -t ${IMAGE} ${PWD}

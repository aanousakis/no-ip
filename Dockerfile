ARG ALPINE_VERSION=3.15

FROM alpine:${ALPINE_VERSION} AS builder

WORKDIR /src

RUN 	   apk update 	                                                    \
	&& apk add wget gcc make libc-dev git                               \
	&& wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz     \
	&& tar xzf noip-duc-linux.tar.gz                 		    \
	&& rm noip-duc-linux.tar.gz                                         \
	&& mv noip* noip_src                                                \
      && git clone https://github.com/0xFireWolf/STUNExternalIP.git       \
      && cd STUNExternalIP                                                \
      && sed -i 's/#include <time.h>/#include <sys\/time.h>\n#include <time.h>/' STUNExternalIP.c    \
      && make

WORKDIR noip_src

RUN  make

FROM alpine:${ALPINE_VERSION}

RUN       apk add --no-cache expect iputils    \
      &&  if [ ! -d /usr/local/etc ]; then mkdir -p /usr/local/etc;fi \
      &&  mkdir /config

RUN addgroup noip && adduser -DH -G noip noip && chown noip /config


USER noip

WORKDIR /scripts/

COPY --from=builder /src/STUNExternalIP/STUNExternalIP /usr/local/bin
COPY --from=builder /src/noip_src/noip2 /usr/local/bin
COPY scripts/* /scripts/


ENTRYPOINT ["/scripts/start_commands.sh"]




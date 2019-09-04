FROM alpine AS builder

WORKDIR /src

RUN 	   apk update 	                                                    \
	&& apk add wget gcc make libc-dev                                   \
	&& wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz     \
	&& tar xzf noip-duc-linux.tar.gz                 		    \
	&& rm noip-duc-linux.tar.gz                                         \
	&& mv noip* noip_src

WORKDIR noip_src

RUN  make

FROM alpine

RUN       apk add --no-cache expect    \
      &&  if [ ! -d /usr/local/etc ]; then mkdir -p /usr/local/etc;fi

WORKDIR /scripts/

COPY --from=builder /src/noip_src/noip2 /usr/local/bin
COPY scripts/* /scripts/


ENTRYPOINT ["/scripts/start_commands.sh"]




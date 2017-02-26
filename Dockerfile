FROM alpine

RUN apk update \
	&& apk add --no-cache \
		curl

ADD eve.sh /bin/eve.sh
RUN chmod +x /bin/eve.sh

ENTRYPOINT /bin/eve.sh

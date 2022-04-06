
CFLAGS ?= -Werror -Wall

LIBSSL_CFLAGS := $(shell pkg-config --cflags libssl)
LIBSSL_LIBS := $(shell pkg-config --libs libssl)

LIBCRYPTO_CFLAGS := $(shell pkg-config --cflags libcrypto)
LIBCRYPTO_LIBS := $(shell pkg-config --libs libcrypto)

CFLAGS += $(LIBCRYPTO_CFLAGS) $(LIBSSL_CFLAGS)
LIBS = $(LIBCRYPTO_LIBS) $(LIBSSL_LIBS)

busybox = busybox
wget = PATH="$(CURDIR):$(PATH)" $(busybox) wget -q -O /dev/null

ssl_client: ssl_client.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS)

.PHONY: clean
clean:
	rm *.o ssl_client

test: ssl_client
	$(wget) https://badssl.com && echo ok
	$(wget) https://tls-v1-2.badssl.com:1012/ && echo ok
	$(wget) https://rsa4096.badssl.com/ && echo ok
	! $(wget) https://expired.badssl.com/ && echo ok
	! $(wget) https://wrong.host.badssl.com/ && echo ok
	! $(wget) https://self-signed.badssl.com/ && echo ok
	! $(wget) https://untrusted-root.badssl.com/ && echo ok
	! $(wget) https://dh480.badssl.com/ && echo ok
#	! $(wget) https://pinning-test.badssl.com/ && echo ok
#	! $(wget) https://revoked.badssl.com/ && echo ok
	$(wget) https://upgrade.badssl.com/ && echo ok


CFLAGS ?= -Werror

LIBTLS_CFLAGS = $(shell pkg-config --cflags libtls)
LIBTLS_LIBS = $(shell pkg-config --libs libtls)

ssl_client: ssl_client.o
	$(CC) $(LIBTLS_CFLAGS) $(CFLAGS) -o $@ $< $(LIBTLS_LIBS) $(LDFLAGS)

.PHONY: clean
clean:
	rm *.o ssl_client

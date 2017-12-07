help:
	@echo "Run 'make install' with adequate permissions to install script in PREFIX/bin (/usr/local/bin by default)."

PREFIX = /usr/local

install:
	install -m 755 -o root -g root ffsync "$(PREFIX)/bin/"

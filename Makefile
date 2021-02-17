SHELL = /bin/sh

all:
	sh setup.sh

install:
	sh install.sh

clean:
	sh clean.sh

re: clean all

.PHONY: install clean re

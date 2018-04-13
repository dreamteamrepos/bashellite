VERSION := 0.0.1
PREFIX := /usr/local
CONFDIR := /etc/bashellite
LOGDIR := /var/log/bashellite
DOCDIR := usr/share/doc

all: user install docs

user:
	getent passwd bashellite || useradd -m -c "Bashellite User" bashellite

install:
	install -m 755 -D bashellite.sh $(DESTDIR)$(PREFIX)/sbin/bashellite
	mkdir -p $(DESTDIR)$(CONFDIR)
	cp -r _metadata/* $(DESTDIR)$(CONFDIR)
	mkdir -p $(DESTDIR)$(LOGDIR)
	chown bashellite $(DESTDIR)$(LOGDIR)

docs:
	mkdir -p $(DESTDIR)$(DOCDIR)
	install -m 644 -DREADME.md LICENSE $(DESTDIR)$(DOCDIR)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/sbin/bashellite
	rm -rf $(DESTDIR)$(CONFDIR)
	rm -rf $(DESTDIR)$(LOGDIR)
	rm -rf $(DESTDIR)$(DOCDIR)
	userdel -r bashellite

.PHONY: all install user docs uninstall

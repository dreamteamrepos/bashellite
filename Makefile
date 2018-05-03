VERSION := 0.0.1
PREFIX := /usr/local
CONFDIR := /etc/bashellite
LOGDIR := /var/log/bashellite
DOCDIR := /usr/share/doc
DATADIR := /var/www/bashellite
PROVIDERDIR := /opt/bashellite/providers.d

all: user install docs

user:
	getent passwd bashellite || useradd -m -c "Bashellite User" bashellite

install:
	install -m 755 -D bashellite.sh $(DESTDIR)$(PREFIX)/sbin/bashellite
	mkdir -p $(DESTDIR)$(CONFDIR)
	mkdir -p $(DESTDIR)$(LOGDIR)
	mkdir -p $(DESTDIR)$(DATADIR)
	mkdir -p $(DESTDIR)$(PROVIDERDIR)
	chown -R bashellite:bashellite $(DESTDIR)$(LOGDIR)
	chown -R bashellite:bashellite $(DESTDIR)$(DATADIR)
	chown -R bashellite:bashellite $(DESTDIR)$(PROVIDERDIR)

docs:
	mkdir -p $(DESTDIR)$(DOCDIR)
	install -m 644 -D README.md LICENSE $(DESTDIR)$(DOCDIR)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/sbin/bashellite
	rm -rf $(DESTDIR)$(CONFDIR)
	rm -rf $(DESTDIR)$(LOGDIR)
	rm -rf $(DESTDIR)$(DOCDIR)
	userdel -r bashellite

.PHONY: all install user docs uninstall

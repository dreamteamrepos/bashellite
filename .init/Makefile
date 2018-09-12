VERSION := 0.0.1
PATHDIR := /usr/local
BINDIR := $(PATHDIR)/bin
LIBDIR := $(PATHDIR)/lib
CONFDIR := /etc/bashellite
OPTDIR := /opt/bashellite
PROVIDERDIR := $(OPTDIR)/providers.d
LOGDIR := /var/log/bashellite
DOCDIR := /usr/share/doc/bashellite
DATADIR := /var/www/html/bashellite
HOMEDIR := /home/bashellite

all: useradd install docs


useradd:
	# Ensures bashellite user exists
	getent passwd bashellite || useradd -c "Bashellite User" bashellite;
	install -o bashellite -g bashellite -m 0644 -D ../home/bashellite/.bashrc $(DESTDIR)$(HOMEDIR)/.bashrc
	install -o bashellite -g bashellite -m 0700 -d $(DESTDIR)$(HOMEDIR)/.bashellite

install: export providers_tld=$(PROVIDERDIR)
install: export bin_dir=$(BINDIR)
install:
	# Ensures bashellite program is latest version and ownership & mode is appropriate
	mkdir -p $(DESTDIR)$(BINDIR)
	chown root:root $(DESTDIR)$(BINDIR)
	chmod 2755 $(DESTDIR)$(BINDIR)
	install -o root -g bashellite -m 0550 -D ../usr/local/bin/bashellite.sh $(DESTDIR)$(BINDIR)/bashellite

	# Ensures bashellite-libs and util-libs are latest and ownership & mode are appropriate
	mkdir -p $(DESTDIR)$(LIBDIR)
	chown root:root $(DESTDIR)$(LIBDIR)
	chmod 2755 $(DESTDIR)$(LIBDIR)
	install -o root -g bashellite -m 0440 -D ../usr/local/lib/bashellite-libs.sh $(DESTDIR)$(LIBDIR)/bashellite-libs.sh
	install -o root -g root -m 0444 -D ../usr/local/lib/util-libs.sh $(DESTDIR)$(LIBDIR)/util-libs.sh

	# Ensures provider directory, provider installer, and providers are latest and ownership & modes are appropriate
	mkdir -p $(DESTDIR)$(PROVIDERDIR)
	chmod 2750 $(DESTDIR)$(OPTDIR)
	chmod 2750 $(DESTDIR)$(PROVIDERDIR)
	cp -fR ../opt/bashellite/providers.d/test/ $(DESTDIR)$(PROVIDERDIR)/test/
	cp -fR ../../bashellite-providers/providers.d/ $(DESTDIR)$(OPTDIR)/ || true
	chown -R root:bashellite $(DESTDIR)/opt/bashellite/
	install -o root -g bashellite -m 0540 -D ../opt/bashellite/install_all_providers.sh $(DESTDIR)$(OPTDIR)/install_all_providers.sh
	$(DESTDIR)$(OPTDIR)/install_all_providers.sh
	chmod -R o-wx $(DESTDIR)$(OPTDIR)
	chmod -R g-w $(DESTDIR)$(OPTDIR)

	# Ensures configuration directories exists and ownership & mode are appropriate
	mkdir -p $(DESTDIR)$(CONFDIR)/repos.conf.d/
	chmod 2750 $(DESTDIR)$(CONFDIR)
	cp -fR ../etc/bashellite/repos.conf.d/test/ $(DESTDIR)$(CONFDIR)/repos.conf.d/test/
	cp -fR ../../bashellite-configs/repos.conf.d/ $(DESTDIR)$(CONFDIR)/ || true
	install -o root -g bashellite -m 0740 -D ../etc/bashellite/bashellite.conf $(DESTDIR)$(CONFDIR)/bashellite.conf
	install -o root -g bashellite -m 0540 -D ../../bashellite-configs/bashellite.conf $(DESTDIR)$(CONFDIR)/bashellite.conf || true
	chown -R root:bashellite $(DESTDIR)$(CONFDIR)
	chmod -R o=r $(DESTDIR)$(CONFDIR)
	chmod -R g-x $(DESTDIR)$(CONFDIR)
	chmod -R g=rX $(DESTDIR)$(CONFDIR)
	chmod -R u-x $(DESTDIR)$(CONFDIR)
	chmod -R u=rwX $(DESTDIR)$(CONFDIR) 

	# Ensures log directory exists and ownership & mode are appropriate
	mkdir -p $(DESTDIR)$(LOGDIR)
	chown -R bashellite:bashellite $(DESTDIR)$(LOGDIR)
	chmod 2750 $(DESTDIR)$(LOGDIR)

	# Ensures default mirror directory is created and ownership & mode are appropriate 
	mkdir -p $(DESTDIR)$(DATADIR)
	chown -R bashellite:bashellite $(DESTDIR)$(DATADIR)
	chmod 2750 $(DESTDIR)$(DATADIR)


docs:
	# Ensures docs directory and docs exists and mode is set appropriately
	mkdir -p $(DESTDIR)$(DOCDIR)
	install -m 644 -D ../README.md ../LICENSE $(DESTDIR)$(DOCDIR)


uninstall:

	# Ensures all bashellite configs, bins, libs, logs, and docs are forceably removed and user is deleted
	rm -rf $(DESTDIR)$(BINDIR)/bashellite
	rm -rf $(DESTDIR)$(LIBDIR)/bashellite-libs.sh
	rm -rf $(DESTDIR)$(CONFDIR)
	rm -rf $(DESTDIR)$(LOGDIR)
	rm -rf $(DESTDIR)$(DOCDIR)
	rm -rf $(DESTDIR)$(OPTDIR)


userdel:

	# Ensures bashellite user is removed from system
	userdel -r bashellite


.PHONY: all install useradd userdel docs uninstall



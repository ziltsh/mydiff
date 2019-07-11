#
# Makefile for mydiff script
#

#MAKEFLAGS = -s
MAKEFLAGS =

I_OPT   = -p -b --suffix=.bak`date '+%Y%M%d'`
INSTALL = /usr/bin/install ${I_OPT}

PKG     = mydiff
DESTDIR = debian

BIN_DIR = ${DESTDIR}${HOME}/bin


default:
	make -s usage
.PHONY: default

usage:
	printf "\n"
	printf "  Usage: make [-s] {i[nstall]|u[ninstall]\n"
	printf "                   {default|usage}\n"
	printf "\n"
.PHONY: usage

i: install
install: install_dir install_file
	make -s printtree
install_dir:
	${INSTALL} -d ${BIN_DIR}
install_file:
	${INSTALL} ${PKG}.bash ${BIN_DIR}/${PKG}
.PHONY: i install install_dir install_file

u: uninstall
uninstall: uninstall_file uninstall_dir
	make -s printtree
uninstall_dir:
	-rmdir ${BIN_DIR}
uninstall_file:
	-rm -v ${BIN_DIR}/mydiff
.PHONY: u uninstall install_dir install_file

printtree:
	find ./${DESTDIR} -ls
.PHONY: printtree

#.

default: install

all: hooks install build

h help:
	@grep '^[a-z]' Makefile

.PHONY: hooks
hooks:
	cd .git/hooks && ln -s -f ../../hooks/pre-push pre-push

install:
	curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.4.21/mdbook-v0.4.21-x86_64-unknown-linux-gnu.tar.gz | tar -xz --directory=bin

s serve:
	mdbook serve

init:
	mdbook init theme --title book --ignore none

build:
	mdbook build

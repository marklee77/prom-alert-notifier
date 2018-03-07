PACKAGE=prom-alert-notifier
.PHONY: all clean glide golint

prom-alert-notifier: main.go vendor
	go build

vendor: glide glide.lock
	glide install

GLIDE := $(shell command -v glide 2>/dev/null)
glide:
ifndef GLIDE
	go get github.com/Masterminds/glide
endif

glide.lock: glide glide.yaml
	glide update

GOLINT := $(shell command -v golint 2>/dev/null)
golint:
ifndef GOLINT
	go get golang.org/x/lint/golint
endif
	golint

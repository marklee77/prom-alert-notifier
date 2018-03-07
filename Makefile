PACKAGE=prom-alert-notifier
.PHONY: clean glide golint install test vendor

prom-alert-notifier: main.go .vendor
	go build

install: prom-alert-notifier test
	go install

clean:
	rm -rf prom-alert-notifier .vendor vendor

GOLINT := $(shell command -v golint 2>/dev/null)
golint:
ifndef GOLINT
	go get golang.org/x/lint/golint
endif
	golint

test: .vendor
	go test $(glide nv)

vendor: .vendor
.vendor: .glide glide.lock
	glide install
	touch .vendor

GLIDE := $(shell command -v glide 2>/dev/null)
glide: .glide
.glide:
ifndef GLIDE
	go get github.com/Masterminds/glide
endif
	touch .glide

glide.lock: .glide glide.yaml
	glide update
	touch glide.lock

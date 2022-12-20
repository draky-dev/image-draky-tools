all: build

build: guard-VERSION
	docker build -t draky-dev/tools:${VERSION} .

guard-%:
	@ if [ "${${*}}" = "" ]; then \
	    echo "Environment variable $* not set"; \
	    exit 1; \
	fi

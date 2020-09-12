docker-compose-env =  HOST_UID_GID="${shell id -u}:${shell id -g}"
docker-compose = $(docker-compose-env) docker-compose

.PHONY: be-test
be-test:
	env MIX_ENV=test mix test

.PHONY: be-setup
be-setup:
	mix deps.get
	mix compile
	mix ecto.setup

compose-setup:
	$(docker-compose) build backend
	$(docker-compose) run --rm backend make be-setup
	$(docker-compose) build frontend
	$(docker-compose) run --rm frontend npm install

compose-up:
	$(docker-compose) up backend frontend

compose-fe-run-%:
	$(docker-compose) run --rm frontend $*

compose-be-run-%:
	$(docker-compose) run --rm backend $*

compose-be-make-%:
	$(docker-compose) run --rm backend make be-$*

APP_VERSION = "0.2.0"
IMAGE_VERSION ?= ${APP_VERSION}
IMAGE_NAME = ex_diet
BUILD_DATE ?= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

build-image:
	docker build -f Dockerfile.release \
		--build-arg APP_VERSION=${APP_VERSION} \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg VCS_REF=${VCS_REF} \
		-t ${IMAGE_NAME}:${IMAGE_VERSION} \
		--compress \
		.
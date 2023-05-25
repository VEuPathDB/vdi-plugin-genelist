IMAGE_NAME := $(shell cat Jenkinsfile | grep '\[ name: ' | sed "s/.\+'\(.\+\)'.\+/\1/")


default:
	@echo "Usage:"
	@echo "  make build"
	@echo
	@echo "    Builds the docker image for local use."
	@echo
	@echo "  make start"
	@echo
	@echo "    Starts the project's docker image as a background container."
	@echo
	@echo "  make stop"
	@echo
	@echo "    Shuts down a running background container for this project."
	@echo
	@echo "  make shell"
	@echo
	@echo "    Opens a bash session in a running instance of this project's docker image."

build:
	@docker compose build

start:
	@docker compose up -d

stop:
	@docker compose down -v

shell:
	@docker exec -it vdi-plugin-genelist-plugin-1 bash

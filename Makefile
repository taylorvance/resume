.PHONY: help
help: ## Display this help message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

TAG := pandoc/latex:3.7.0-ubuntu

.PHONY: setup teardown
setup: ## Install the docker image.
	docker pull $(TAG)
teardown: ## Show how to uninstall the docker image.
	@echo "To uninstall the docker image, run 'docker rmi $(TAG)'"

.PHONY: start
start: ## Convert markdown resume to output formats.
	@echo "Converting resume.md to output formats..."
	docker run --rm -v $(shell pwd):/data $(TAG) -s -o /data/docs/index.html --css=/data/resume.css /data/resume.md
	docker run --rm -v $(shell pwd):/data $(TAG) -s -o /data/docs/resume.pdf -V geometry:margin=0.9in -V fontsize=12pt /data/resume.md
	docker run --rm -v $(shell pwd):/data $(TAG) -s -o /data/docs/resume.txt -f markdown -t plain /data/resume.md

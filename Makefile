.PHONY: help
help: ## Display this help message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

TAG := pandoc/latex:3.7.0-ubuntu

.PHONY: setup teardown
setup: ## Install the docker image.
	docker pull $(TAG)

.PHONY: html pdf
html: ## Convert the markdown file to HTML.
	docker run --rm -v $(shell pwd):/data $(TAG) -s -o /data/resume.html /data/resume.md
pdf: ## Convert the markdown file to PDF.
	docker run --rm -v $(shell pwd):/data $(TAG) -s -o /data/resume.pdf /data/resume.md -V geometry:margin=1in -V fontsize=12pt

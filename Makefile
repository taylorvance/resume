.PHONY: help
help: ## Display this help message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

TAG := pandoc/latex:3.7.0-ubuntu

.PHONY: setup teardown
setup: ## Install the docker image.
	mkdir -p ${PWD}/docs
	docker pull $(TAG)
teardown: ## Show how to uninstall the docker image.
	@echo "To uninstall: docker rmi $(TAG)"

OUTPUT_FILENAME := Taylor_Vance_Resume

docs/index.html: resume.md resume.css
	docker run --rm -v $(shell pwd):/data $(TAG) -o /data/docs/index.html -s --embed-resources --css=/data/resume.css /data/resume.md
docs/$(OUTPUT_FILENAME).pdf: resume.md
	docker run --rm -v $(shell pwd):/data $(TAG) -o /data/docs/$(OUTPUT_FILENAME).pdf -s -V geometry:margin=0.9in -V fontsize=12pt /data/resume.md
docs/$(OUTPUT_FILENAME).txt: resume.md
	docker run --rm -v $(shell pwd):/data $(TAG) -o /data/docs/$(OUTPUT_FILENAME).txt -s -f markdown -t plain /data/resume.md

.PHONY: start
start: docs/index.html docs/$(OUTPUT_FILENAME).pdf docs/$(OUTPUT_FILENAME).txt ## Generate the resume in HTML, PDF, and plain text formats.
	@echo "Resume generated successfully in docs/ directory."

.PHONY: deploy
deploy: start ## Rebuild and push generated resumes to GitHub Pages.
	git add docs/index.html docs/$(OUTPUT_FILENAME).pdf docs/$(OUTPUT_FILENAME).txt
	git commit -m "Update resume" || echo "No changes to commit"
	git push

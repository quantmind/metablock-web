.PHONY: help
help:
	@echo ======================================================================================
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo ======================================================================================

.PHONY: build-example
build-example:		## build the example bundle deployed by CI
	@cd example && npm i && npm run build

.PHONY: image
image:			## build the action docker image
	@docker build -t metablock-web .

.PHONY: release
release:		## tag current version (from VERSION) and push
	$(eval VERSION := $(shell cat VERSION))
	@read -p "Tagging with v$(VERSION), are you sure? [Y/n] " ans; \
	ans=$${ans:-Y}; \
	if [ "$$ans" = "Y" ] || [ "$$ans" = "y" ]; then \
		git tag -a v$(VERSION) -m "v$(VERSION)" && git push origin v$(VERSION); \
	else \
		echo "Aborted."; \
	fi

.PHONY: terminal
terminal:		## open a shell in the action image
	@docker run -it --rm \
		-v $(PWD):/action \
		metablock-web bash

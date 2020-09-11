MAJOR_PATTERN := ^[0-9]\+
MINOR_PATTERN := ^[0-9]\+\.[0-9]\+
PATCH_PATTERN := ^[0-9]\+\.[0-9]\+\.[0-9]\+
BUILD_PATTERN := ^[0-9]\+\.[0-9]\+\.[0-9]\+\-[0-9]\+
VERSION_COMMAND := docker run -it deciphernow/nexus:latest cat /usr/local/share/nexus/VERSION

.PHONY: build
build:
	@echo "Building docker image(s)..."
	@docker build -t deciphernow/nexus:latest .
	@docker tag deciphernow/nexus:latest deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(MAJOR_PATTERN)')
	@docker tag deciphernow/nexus:latest deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(MINOR_PATTERN)')
	@docker tag deciphernow/nexus:latest deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(PATCH_PATTERN)')
	@docker tag deciphernow/nexus:latest deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(BUILD_PATTERN)')

.PHONY: publish
publish: build
	@echo "Publishing docker image(s)..."
	@docker push deciphernow/nexus:latest
	@docker push deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(MAJOR_PATTERN)')
	@docker push deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(MINOR_PATTERN)')
	@docker push deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(PATCH_PATTERN)')
	@docker push deciphernow/nexus:$(shell $(VERSION_COMMAND) | grep -o '$(BUILD_PATTERN)')

USER=isahilsundrani
IMAGE_NAME=basix
TAG=latest
PLATFORMS=linux/amd64,linux/arm64/v8

# to build and push for multi-archtype
doc-build:
	docker buildx use mybuilder
	docker buildx build --platform $(PLATFORMS) -t $(USER)/$(IMAGE_NAME):$(TAG) . --push

# to push on host based archtype
doc-push:
	docker tag $(IMAGE_NAME) $(USER)/$(IMAGE_NAME):$(TAG)
	docker push $(USER)/$(IMAGE_NAME):$(TAG)

# to pull from hub
doc-pull:
	docker pull $(USER)/$(IMAGE_NAME)

# to remove the image
doc-clean:
	docker rmi $(IMAGE_NAME):$(TAG)

git-push:
	@git commit -m "$${msg:-Auto-commit}"
	@git push origin main

git-reset:
	git reset --hard

help:
	@echo "Available commands:"
	@echo "  make doc-build   - Build and push a multi-architecture Docker image"
	@echo "  make doc-push    - Tag and push the Docker image"
	@echo "  make doc-clean   - Remove the Docker image"
	@echo "  make doc-pull    - Pull the Docker image"
	@echo "  make git-push    - Commit changes and push to GitHub"
	@echo "  make git-reset   - Reset Git changes"
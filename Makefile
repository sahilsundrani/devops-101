USER=isahilsundrani
IMAGE_NAME=basix
TAG=latest
PLATFORMS=linux/amd64,linux/arm64/v8

# --- DOCKER ---
doc-build:
	docker build -t basix .

# this is to run in development mode
doc-run-dev:
	docker run -it --rm --network mynetwork -p 3000:3000 -v ${PWD}:/app basix 

# this is for testing the final build (For Cloud too)
doc-run:
	docker run -d -p 3000:3000 $(USER)/$(IMAGE_NAME)
	
# to build and push for multi-archtype
doc-build-multi:
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

# --- GIT ---
git-push:
	@git commit -m "$${msg:-Auto-commit}"
	@git push origin main

git-reset:
	git reset --hard

# --- MONGODB ---
MONGO_CONTAINER_NAME=mongodb
MONGO_PORT=27017
MONGO_USER=admin
MONGO_PASS=password
MONGO_DB=mydatabase
MONGO_VOLUME=mongodb_data

# Run MongoDB container
run-mongo:
	docker run -d --name $(MONGO_CONTAINER_NAME) \
		--network mynetwork \
		-p $(MONGO_PORT):27017 \
		-e MONGO_INITDB_ROOT_USERNAME=$(MONGO_USER) \
		-e MONGO_INITDB_ROOT_PASSWORD=$(MONGO_PASS) \
		-e MONGO_INITDB_DATABASE=$(MONGO_DB) \
		-v $(MONGO_VOLUME):/data/db \
		mongo

# Stop and remove the container
stop-mongo:
	docker stop $(MONGO_CONTAINER_NAME) && docker rm $(MONGO_CONTAINER_NAME)

# Show logs
logs-mongo:
	docker logs -f $(MONGO_CONTAINER_NAME)

# Remove MongoDB volume (⚠ This will delete all data)
clean-mongo:
	docker volume rm $(MONGO_VOLUME)

help:
	@echo "Available commands:"
	@echo "  make doc-build   - Build and push a multi-architecture Docker image"
	@echo "  make doc-push    - Tag and push the Docker image"
	@echo "  make doc-clean   - Remove the Docker image"
	@echo "  make doc-pull    - Pull the Docker image"
	@echo "  make git-push    - Commit changes and push to GitHub"
	@echo "  make git-reset   - Reset Git changes"
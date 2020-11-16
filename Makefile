.PHONY: clean docker-compose.yaml

.PHONY: run
## Run docker-compose up
run:docker-compose.yaml
	docker-compose -f $< up

.PHONY: build
## Rebuild docker container from file
build:docker-compose.yaml
	docker-compose -f $< up --build

.PHONY: stop
## Stop running container
stop:docker-compose.yaml
	docker-compose -f $< down

.PHONY: clean
## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	find . -type -d name "ipynb_checkpoints" -delete

.PHONY: lint
## Lint using flake8
lint:
	flake8 src

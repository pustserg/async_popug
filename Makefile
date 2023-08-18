rebuild:
	docker compose up --build

build:
	docker compose build

start:
	docker compose up

authrailsc:
	docker compose run --rm auth rails c

tasksrailsc:
	docker compose run --rm tasks rails c

accountsrasilsc:
	docker compose run --rm accounts rails c

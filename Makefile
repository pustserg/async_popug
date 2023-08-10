rebuild:
	docker compose up --build

start:
	docker compose up

authrailsc:
	docker compose run --rm auth rails c

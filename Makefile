
all: prune reload

stop:
	docker compose -f srcs/docker-compose.yml down

clean: stop
	docker system prune -af

fclean: clean
	sudo rm -rf /home/oaizab/data

prune: stop
	docker system prune -f

reload:
	docker compose -f srcs/docker-compose.yml up -d --build

.PHONY: stop clean fclean prune reload all
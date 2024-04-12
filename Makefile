name = Grafana Logging

NO_COLOR=\033[0m	# Color Reset
COLOR_OFF='\e[0m'       # Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow
RED='\e[1;31m'          # Red
GREEN='\e[1;32m'        # Green
YELLOW='\e[1;33m'       # Yellow
BLUE='\e[1;34m'         # Blue
PURPLE='\e[1;35m'       # Purple
CYAN='\e[1;36m'         # Cyan
WHITE='\e[1;37m'        # White
UCYAN='\e[4;36m'        # Cyan
USER_ID = $(shell id -u)

all:
	@printf "Launch configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml up -d
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build grafana

help:
	@echo -e "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- make				: Launch configuration"
	@echo -e "$(WARN_COLOR)- make build			: Building configuration"
	@echo -e "$(WARN_COLOR)- make congra			: Connect to grafana container"
	@echo -e "$(WARN_COLOR)- make conki			: Connect to loki container"
	@echo -e "$(WARN_COLOR)- make conpro			: Connect to prometheus container"
	@echo -e "$(WARN_COLOR)- make conpt			: Connect to promtail container"
	@echo -e "$(WARN_COLOR)- make conpg			: Connect to pushgateway container"
	@echo -e "$(WARN_COLOR)- make conpos			: Connect to postgres container"
	@echo -e "$(WARN_COLOR)- make down			: Stopping configuration"
	@echo -e "$(WARN_COLOR)- make env			: Create .env-file"
	@echo -e "$(WARN_COLOR)- make push			: Push changes to the github"
	@echo -e "$(WARN_COLOR)- make re			: Rebuild all configuration"
	@echo -e "$(WARN_COLOR)- make regra			: Rebuild grafana configuration"
	@echo -e "$(WARN_COLOR)- make relo			: Rebuild loki configuration"
	@echo -e "$(WARN_COLOR)- make repro			: Rebuild prometheus configuration"
	@echo -e "$(WARN_COLOR)- make rept			: Rebuild promtail configuration"
	@echo -e "$(WARN_COLOR)- make repg			: Rebuild pushgateway configuration"
	@echo -e "$(WARN_COLOR)- make repos			: Rebuild postgres configuration"
	@echo -e "$(WARN_COLOR)- make ps			: View configuration"
	@echo -e "$(WARN_COLOR)- make clean			: Cleaning configuration$(NO_COLOR)"

build:
	@printf "$(YELLOW)==== Building configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --build
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build grafana

congra:
	@printf "$(ERROR_COLOR)==== Connect to grafana container... ====$(NO_COLOR)\n"
	@docker exec -it grafana sh

conki:
	@printf "$(ERROR_COLOR)==== Connect to loki container... ====$(NO_COLOR)\n"
	@docker exec -it loki sh

conpro:
	@printf "$(ERROR_COLOR)==== Connect to prometheus container... ====$(NO_COLOR)\n"
	@docker exec -it prometheus sh

conpt:
	@printf "$(ERROR_COLOR)==== Connect to promtail container... ====$(NO_COLOR)\n"
	@docker exec -it promtail bash

conpg:
	@printf "$(ERROR_COLOR)==== Connect to pushgateway container... ====$(NO_COLOR)\n"
	@docker exec -it pushgateway sh

conpos:
	@printf "$(ERROR_COLOR)==== Connect to postgres container... ====$(NO_COLOR)\n"
	@docker exec -it postgres sh

down:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml down

env:
	@printf "$(ERROR_COLOR)==== Create environment file for ${name}... ====$(NO_COLOR)\n"
	@if [ -f .env ]; then \
		rm .env; \
	fi; \
	cp .env.example .env; \
	echo "USER_ID=${USER_ID}" >> .env

logs:
	@printf "$(YELLOW)==== ${name} logs... ====$(NO_COLOR)\n"
	@docker logs dash

push:
	@bash push.sh

re: down
	@printf "$(OK_COLOR)==== Rebuild configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build grafana

regra:
	@printf "$(OK_COLOR)==== Rebuild grafana... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build grafana

relo:
	@printf "$(OK_COLOR)==== Rebuild loki... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build loki

repro:
	@printf "$(OK_COLOR)==== Rebuild prometheus... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build prometheus

rept:
	@printf "$(OK_COLOR)==== Rebuild promtail... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build promtail

repg:
	@printf "$(OK_COLOR)==== Rebuild pushgateway... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build pushgateway

repos:
	@printf "$(OK_COLOR)==== Rebuild postgres... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build postgres

ps:
	@printf "$(BLUE)==== View configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml ps

clean: down
	@printf "$(ERROR_COLOR)==== Cleaning configuration ${name}... ====$(NO_COLOR)\n"
	

fclean:
	@printf "$(ERROR_COLOR)==== Total clean of all configurations docker ====$(NO_COLOR)\n"
	@yes | docker system prune -a
	# Uncommit if necessary:
	# @docker stop $$(docker ps -qa)
	# @docker system prune --all --force --volumes
	# @docker network prune --force
	# @docker volume prune --force

.PHONY	: all help build down logs re refl repa reps ps clean fclean

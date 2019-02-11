
# distributed algorithms, n.dulay, 18 jan 18
# Makefile, v1

PEERS    = 10
MAIN     = Broadcast.main
MAIN_NET = Broadcast.main_net

PROJECT  = da347
NETWORK  = $(PROJECT)_network

LOCAL	 = mix run --no-halt -e $(MAIN) $(PEERS)
COMPOSE  = MAIN=$(MAIN_NET) PEERS=$(PEERS) docker-compose -p $(PROJECT)

compile:
	mix compile

dockercompile:
	mix clean
	docker run  -it --rm -v "$(PWD)":/project -w /project elixir:alpine mix compile

run:
	$(LOCAL)

clean:
	mix clean

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up

down:
	$(COMPOSE) down
	make show

show:
	@echo ----------------------
	@make ps
	@echo ----------------------
	@make network

show2:
	@echo ----------------------
	@make ps2
	@echo ----------------------
	@make network

ps:
	docker ps -a --format 'table {{.Names}}\t{{.Image}}'

ps2:
	docker ps -a -s

network net:
	docker network ls

inspect:
	docker network inspect $(NETWORK)

netrm:
	docker network rm $(NETWORK)
conrm:
	docker rm $(ID)

kill:
	docker rm -f `docker ps -a -q`
	docker network rm $(NETWORK)

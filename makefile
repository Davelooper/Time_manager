db = db
elixir_container = $(shell docker ps --filter "name=elixtime_manager-elixir-1ir" --format "{{.Names}}")
vuejs = 473d486e1fe94f5b29f47afc1f60336dda0d58416b3dccd469e3f130f91a4699

win-start:
	cmd /c start start.bat

lin-start:
	./start.sh
# Connexion au shell Elixir
elixir-bash:
	@echo "Connecting to Elixir container..."
	docker exec -it time_manager-elixir-1 sh

# Nettoyage du projet Elixir
clean:
	@echo "Cleaning Elixir project..."
	docker exec -it time_manager-elixir-1 sh -c "mix clean"

# Commandes Ecto pour gérer la base de données
db-reset:
	@echo "Resetting the database..."
	docker exec -it time_manager-elixir-1 sh -c "mix ecto.reset"

db-drop:
	@echo "Dropping the database..."
	docker exec -it time_manager-elixir-1 sh -c "mix ecto.drop"

db-create:
	@echo "Creating the database..."
	docker exec -it time_manager-elixir-1 sh -c "mix ecto.create"

db-migrate:
	@echo "Migrating the database..."
	docker exec -it time_manager-elixir-1 sh -c "mix ecto.migrate"

deps:
	docker exec -it time_manager-elixir-1 sh -c "mix deps.get"


routes:
	docker exec -it time_manager-elixir-1 sh -c "mix phx.routes"

reset-elixir:
	@echo "Stopping and removing the Elixir container..."
	docker-compose -f docker-compose.dev.yaml down -v elixir
	@echo "Removing old Elixir image..."
	docker rmi time_manager-elixir
	@echo "Rebuilding and starting the Elixir container..."
	docker-compose -f docker-compose.dev.yaml up -d --build elixir
	@echo "Elixir VM has been reset successfully!"

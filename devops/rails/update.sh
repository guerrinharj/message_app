
chmod +x ./devops/rails/update.sh

echo "Running database migrations"
docker compose run web rails db:migrate

echo "Running database seeds"
docker compose run web rails db:seed

echo "Pruning stopped containers..."
docker container prune -f

echo "Done."

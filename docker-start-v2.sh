envsubst < /app/config/database.example.yml > /app/config/database.yml
envsubst < /app/config/environment.example.yml > /app/config/environment.yml
bundle exec rake staytus:build staytus:upgrade
bundle exec foreman start

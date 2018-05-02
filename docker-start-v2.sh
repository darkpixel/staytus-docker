envsubst < /app/config/database.example.yml > /app/config/database.yml
envsubst < /app/config/environment.example.yml > /app/config/environment.yml

if [ -n "${DB_INIT+set}" ]; then
    echo '$DB_INIT was set, initializing database'
    bundle exec rake staytus:build staytus:install
fi

bundle exec rake staytus:build staytus:upgrade
bundle exec foreman start

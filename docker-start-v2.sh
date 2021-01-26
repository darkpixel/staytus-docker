envsubst < /app/config/database.example.yml > /app/config/database.yml
envsubst < /app/config/environment.example.yml > /app/config/environment.yml

ls -1 *.patch | xargs git apply

if [ -n "${DB_INIT+set}" ]; then
    echo '$DB_INIT was set, initializing database'
    bundle exec rake staytus:build staytus:install
fi

echo DATABASE CONFIG
cat /app/config/database.yml
echo ENV CONFIG
cat /app/config/environment.yml
bundle exec rake staytus:build staytus:upgrade
procodile start
#bundle exec foreman start

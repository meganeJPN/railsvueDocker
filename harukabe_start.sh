#!/bin/bash

if [ "$DEPLOYMENT_STAGE" = 'production' ]; then
  echo 'release stage: production'
  # コンテナを停止、ボリュームも削除
  echo 'stop containers...'
  docker compose down
  # 最新のコードを取得
  echo 'pull latest code...'
  cd ../HarukabeServer && git stash && git checkout master && git pull origin master && cd ../HarukabeDocker
  cd ../HarukabeClient && git stash && git checkout master && git pull origin master && cd ../HarukabeDocker
  # envファイルを作成
  echo 'create env file...'
  echo 'DEPLOYMENT_STAGE=production' > env_file.env
  echo 'RAILS_ENV=production' >> env_file.env
  echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> env_file.env
  # nginxの設定ファイル
  echo 'create nginx conf...'
  echo "NGINX_PORT=80" > .env
  cp ./nginx/production.conf ./nginx/default.conf
  # build
  echo 'docker compose build...'
  docker compose build
  # db
  echo 'db:create db:migrate...'
  docker compose run api bash wait-for-db.sh
  docker compose run api rails db:create
  docker compose run api rails db:migrate
  # up
  echo 'docker compose up...'
  docker compose up -d
elif [ "$DEPLOYMENT_STAGE" = 'staging' ]; then
  echo 'release stage: staging'
  # コンテナを停止、ボリュームも削除
  echo 'stop containers...'
  docker compose down
  # 最新のコードを取得
  echo 'pull latest code...'
  cd ../HarukabeServer && git stash && git checkout develop && git pull origin develop && cd ../HarukabeDocker
  cd ../HarukabeClient && git stash && git checkout develop && git pull origin develop && cd ../HarukabeDocker
  # envファイルを作成
  echo 'create env file...'
  echo 'DEPLOYMENT_STAGE=staging' > env_file.env
  echo 'RAILS_ENV=staging' >> env_file.env
  echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> env_file.env
  # nginxの設定ファイル
  echo 'create nginx conf...'
  echo "NGINX_PORT=80" > .env
  cp ./nginx/staging.conf ./nginx/default.conf
  # build
  echo 'docker compose build...'
  docker compose build
  # db
  echo 'db:create db:migrate...'
  docker compose run api bash wait-for-db.sh
  docker compose run api rails db:create
  docker compose run api rails db:migrate
  # up
  echo 'docker compose up...'
  docker compose up -d
else
  echo 'release stage: development'
  # コンテナを停止、ボリュームも削除
  echo 'stop containers...'
  docker compose down
  # 最新のコードを取得
  # echo 'pull latest code...'
  # cd ../HarukabeServer && git stash && git checkout develop && git pull origin master && cd ../HarukabeDocker
  # cd ../HarukabeClient && git stash && git checkout develop && git pull origin master && cd ../HarukabeDocker
  # envファイルを作成
  echo 'create env file...'
  echo 'DEPLOYMENT_STAGE=development' > env_file.env
  echo 'RAILS_ENV=development' >> env_file.env
  echo "POSTGRES_PASSWORD=password" >> env_file.env
  # nginxの設定ファイル
  echo 'create nginx conf...'
  echo "NGINX_PORT=4000" > .env
  cp ./nginx/develop.conf ./nginx/default.conf
  # build
  docker compose build
  echo 'docker compose build...'
  # db
  echo 'db:create db:migrate...'
  docker compose run api bash wait-for-db.sh
  docker compose run api rails db:create
  docker compose run api rails db:migrate
  # up
  echo 'docker compose up...'
  docker compose up -d
fi

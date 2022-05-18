## 概要

- Harukabeの開発環境をつくる docker-compose
- Rails API と　Vue Client　は別レポジトリ
- git modulesはつかってないので、ディレクトリ構成をまもること

## Installation

### clean docker (optional)

```
# 動いているコンテナがあれば全て止める
docker stop $(docker ps -q)
# コンテナとネットワークを削除
docker system prune
# ボリュームを削除
docker volume prune
```

### clone repository

```
git clone git@github.com:woodxjp/HarukabeDocker.git
git clone git@github.com:woodxjp/HarukabeServer.git
git clone git@github.com:woodxjp/HarukabeClient.git
```

ディレクトリ構成

```
HarukabeDocker/
    |-- docker-compose.yml
HarukabeServer/
    |-- Dockerfile
    |-- ...
HarukabeClient/
    |-- Dockerfile
    |-- ...
```

### Build Containers

```
docker compose build --no-cache
```

### Create Database

```
docker compose run api rails db:create
```

### Run All

```
bash harukabe_start.sh
# nginx runs on https://127.0.0.1:4000
```

### Ports
- API server: 127.0.0.1:8000
- Cliet dev server: 127.0.0.1:3000
- DB: 127.0.0.1:5432
- nginx: 127.0.0.1:4000



## How to use (Server)

--------

### Rails comamnd
```shell
# コンテナが動いていればexecでよい　
# rails generate
docker compose exec api rails generate scaffold Micropost content:text user_id:integer
# rails console
docker compose exec api rails console
# rails test
docker compose exec api rails test

```

### Gem installation
```shell
# Gemfileを書いてからコンテナイメージを作りなおす
docker compose stop (optional)
docker compose build
docker compose up
```

### Migration
```shell
# migrationファイルを書いてから
docker compose exec api db:migrate
```

## How to use (Client)

---

### Add packages
```shell
docker comopse exec client /bin/bash
cd /usr/src
npm install ***
```

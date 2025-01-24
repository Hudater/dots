#!/bin/sh
mkdir -p ${CFG_DIR}/serviceName #
mkdir -p ${CFG_DIR}/serviceName/{multiple,subdirs} #
docker compose up -d

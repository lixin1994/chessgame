#!/bin/bash

export PORT=5100

cd ~/www/memory
./bin/chessgame stop || true
./bin/chessgame start


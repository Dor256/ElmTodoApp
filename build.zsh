#!/bin/zsh
cd client && elm make src/* --optimize --output dist/index.js && cd ..

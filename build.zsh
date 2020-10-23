#!/bin/zsh
cd client && elm make src/* --output dist/index.js && cd ..

#!/usr/bin/env bash

set -ef -o pipefail

# rm -rf vendor/bundle
docker run -v $(pwd):$(pwd) -w $(pwd) -it lambci/lambda:20201024-build-ruby2.7 bundle --deployment --without "development test"
rm -f .bundle/config

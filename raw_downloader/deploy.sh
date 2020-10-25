#!/usr/bin/env bash

set -ef -o pipefail
readonly script_dir=$(cd "$(dirname "$0")" && pwd)

function package() {
    sam package --template-file "${script_dir}/template.yml" \
        --s3-bucket $BUCKET_NAME \
        --output-template-file "${script_dir}/packaged-template.yml" \
        --profile $PROFILE_NAME
}

function deploy() {
    sam deploy --template-file "${script_dir}/packaged-template.yml" \
        --region ap-northeast-1 \
        --stack-name wakatime-raw-downloader-stack \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides "WakatimeApiKey=$WAKATIME_API_KEY RawOutputBucketArn=${RAW_OUTPUT_BUCKET_ARN} TwConsumerKey=${TW_CONSUMER_KEY} TwConsumerSecret=${TW_CONSUMER_SECRET} TwAccessToken=${TW_ACCESS_TOKEN} TwAccessTokenSecret=${TW_ACCESS_TOKEN_SECRET}" \
        --profile $PROFILE_NAME
}

package
deploy

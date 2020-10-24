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
        --parameter-overrides "WakatimeApiKey=\"$WAKATIME_API_KEY\" RawOutputBucketArn=${RAW_OUTPUT_BUCKET_ARN}" \
        --profile $PROFILE_NAME
}

package
deploy

#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CloudformationStack } from '../lib/cloudformation-stack';

const app = new cdk.App();
new CloudformationStack(app, 'CloudformationStack');

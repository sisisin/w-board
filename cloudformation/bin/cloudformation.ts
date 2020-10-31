#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { VpcStack } from '../lib/vpc-stack';
import { deployStages } from '../lib/constants';
import { DBStack } from '../lib/db-stack';

const app = new cdk.App();
deployStages.forEach((deployStage) => {
  const vpcStack = new VpcStack(app, `${deployStage}VpcStack`, {}, { deployStage });
  const dbStack = new DBStack(app, `${deployStage}DBStack`, {}, { deployStage, vpcStack });
});

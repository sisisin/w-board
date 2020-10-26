import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import { DeployStage } from './constants';

interface VpcStackProps {
  deployStage: DeployStage;
}
export class VpcStack extends cdk.Stack {
  readonly vpc: ec2.Vpc;
  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps, vpcStackProps: VpcStackProps) {
    super(scope, id, props);

    const { deployStage } = vpcStackProps;

    this.vpc = new ec2.Vpc(this, `${deployStage}Vpc`, {
      cidr: '10.20.0.0/16',
      subnetConfiguration: [{ name: 'Isolated', subnetType: ec2.SubnetType.ISOLATED }],
      maxAzs: 2,
    });
  }
}

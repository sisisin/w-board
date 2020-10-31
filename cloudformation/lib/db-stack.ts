import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import * as rds from '@aws-cdk/aws-rds';
import { dbPassword, DeployStage } from './constants';
import { VpcStack } from './vpc-stack';

interface DBStackProps {
  deployStage: DeployStage;
  vpcStack: VpcStack;
}
export class DBStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps, vpcStackProps: DBStackProps) {
    super(scope, id, props);

    const { deployStage, vpcStack } = vpcStackProps;

    const cluster = new rds.ServerlessCluster(this, `${deployStage}DBCluster`, {
      engine: rds.DatabaseClusterEngine.auroraMysql({ version: rds.AuroraMysqlEngineVersion.VER_5_7_12 }),
      vpc: vpcStack.vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.ISOLATED },
      credentials: {
        username: 'foo',
        password: cdk.SecretValue.plainText(dbPassword),
      },
      enableHttpEndpoint: true,
      scaling: {
        minCapacity: rds.AuroraCapacityUnit.ACU_1,
        maxCapacity: rds.AuroraCapacityUnit.ACU_1,
        autoPause: cdk.Duration.minutes(10),
      },
    });
  }
}

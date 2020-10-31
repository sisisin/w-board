export const deployStages = ['Production'] as const;
export type DeployStage = typeof deployStages[number];

export const dbPassword = getOrThrow(process.env.WB_DB_PASSWORD);

function getOrThrow<T>(value: T | undefined | null): T {
  if (value == null) throw new Error(`value '${value}' must be present`);

  return value;
}

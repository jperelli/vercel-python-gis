import { BuildOptions, Lambda } from "@vercel/build-utils";
import execa from "execa";

export const version = 2;

export async function build({
  workPath,
  files,
  entrypoint,
  meta = {},
  config = {},
}: BuildOptions) {
  console.log(process.cwd())

  await execa.command(process.cwd() + "/src/build.sh", { shell: true });

  const lambda = new Lambda({
    files,
    ...config,
    handler: entrypoint,
    runtime: "python3.9",
  });

  return {
    output: lambda,
  };
}

import { BuildOptions, Lambda } from "@vercel/build-utils";
import execa from "execa";
import path from "path";

export const version = 1;

export async function build({
  workPath,
  files,
  entrypoint,
  meta = {},
  config = {},
}: BuildOptions) {
  await execa.command(path.resolve(__dirname, "../src/build.sh"), { shell: true });

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

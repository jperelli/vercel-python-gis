import {
  BuildOptions,
  Lambda,
  shouldServe,
  download,
} from "@vercel/build-utils";
import execa from "execa";
import path from "path";
import fs from "fs-extra";

export const version = 2;

export { shouldServe };

fs.chmodSync(path.resolve(__dirname, "../src/build.sh"), 0o755);

export async function build({
  workPath,
  files,
  entrypoint,
  meta = {},
  config = {},
}: BuildOptions) {
  await download(files, workPath, meta);

  await execa.command(path.resolve(__dirname, "../src/build.sh"), {
    shell: true,
  });

  const output = new Lambda({
    files,
    ...config,
    handler: entrypoint,
    runtime: "python3.9",
  });

  return {
    output,
  };
}

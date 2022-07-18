"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.build = exports.shouldServe = exports.version = void 0;
const build_utils_1 = require("@vercel/build-utils");
Object.defineProperty(exports, "shouldServe", { enumerable: true, get: function () { return build_utils_1.shouldServe; } });
const execa_1 = require("execa");
const path_1 = __importDefault(require("path"));
const fs_extra_1 = __importDefault(require("fs-extra"));
exports.version = 3;
fs_extra_1.default.chmodSync(path_1.default.resolve(__dirname, "../src/build.sh"), 0o755);
function build({ workPath, files, entrypoint, meta = {}, config = {}, }) {
    var _a;
    return __awaiter(this, void 0, void 0, function* () {
        yield (0, build_utils_1.download)(files, workPath, meta);
        const subprocess = (0, execa_1.execa)(path_1.default.resolve(__dirname, "../src/build.sh"), {
            shell: true,
        });
        (_a = subprocess.stdout) === null || _a === void 0 ? void 0 : _a.pipe(process.stdout);
        const { stdout } = yield subprocess;
        console.log(stdout);
        const output = new build_utils_1.Lambda(Object.assign(Object.assign({ files }, config), { handler: entrypoint, runtime: "python3.9" }));
        return {
            output,
        };
    });
}
exports.build = build;

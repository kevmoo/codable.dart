import * as fs from 'fs';
import { pathToFileURL } from 'url';

const wasmPath = process.argv[2];
const mjsPath = process.argv[3];
const scriptArgs = process.argv.slice(4);

const mjsModule = await import(pathToFileURL(mjsPath).href);
const bytes = fs.readFileSync(wasmPath);
const compiled = await mjsModule.compile(bytes);
const instance = await compiled.instantiate();
await instance.invokeMain(...scriptArgs);

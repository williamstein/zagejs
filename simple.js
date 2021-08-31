const { WASI } = require("@wasmer/wasi");
const wasi = new WASI({
  args: process.argv,
  env: process.env,
});

const fs = require("fs");
const source = fs.readFileSync("./simple.wasm");
const typedArray = new Uint8Array(source);

const stub = (s) => () => console.log("stub", s);

const simple = {};

const env = {
  raise: stub("raise"),
  main: console.log,
};

WebAssembly.instantiate(typedArray, {
  env,
  wasi_snapshot_preview1: wasi.wasiImport,
}).then((result) => {
  wasi.start(result.instance);
  simple.instance = result.instance;
  console.log("f() = ", result.instance.exports.f());
});

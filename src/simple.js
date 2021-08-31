const { WASI } = require("@wasmer/wasi");
const wasi = new WASI({
  args: process.argv,
  env: process.env,
});

const fs = require("fs");
const source = fs.readFileSync(`${__dirname}/../build/simple.wasm`);
const typedArray = new Uint8Array(source);

const stub = (s) => () => console.log("stub", s);

const simple = {};

const env = {
  raise: stub("raise"),
  main: console.log,
};

const encoder = new TextEncoder();
function stringToU8(s) {
  const array = new Int8Array(
    simple.instance.exports.memory.buffer,
    0,
    s.length + 1
  );
  array.set(encoder.encode(s));
  array[s.length] = 0;
  return array;
}

WebAssembly.instantiate(typedArray, {
  env,
  wasi_snapshot_preview1: wasi.wasiImport,
}).then((result) => {
  wasi.start(result.instance);
  simple.instance = result.instance;
  console.log("f() = ", result.instance.exports.f());

  result.instance.exports.fromString(stringToU8("hello world"));

  exports.isPseudoPrime = (n) => {
    return result.instance.exports.isPseudoPrime(stringToU8(`${n}`));
  };

  console.log("isPseudoPrime(2021) = ", exports.isPseudoPrime(2021));

  exports.createInteger = (n) => {
    return result.instance.exports.createInteger(stringToU8(`${n}`));
  };
});

FLAGS = -I. -L. #-O ReleaseFast

install:
	npm ci

build-dir:
	mkdir -p build

build/simple.wasm: src/simple.zig build-dir
	cd src && zig build-lib -target wasm32-wasi ${FLAGS} simple.zig libgmp.a -lc -dynamic
	mv src/simple.wasm build

run-wasm: src/simple.js build/simple.wasm
	cd build && node ../src/simple.js

build/native: src/simple.zig src/native.zig build-dir
	cd src && zig build-exe native.zig ${FLAGS} -lgmpnative -lc
	mv src/native build/native

run-native: build/native
	./build/native

build/native-custom: src/simple.zig src/native.zig build-dir
	cd src && zig build-exe native-custom-allocator.zig ${FLAGS} -lgmpnative -lc
	mv src/native-custom-allocator build/native-custom-allocator

run-native-custom: build/native-custom
	./build/native-custom-allocator

test-native: src/gmp.zig
	cd src && zig test gmp.zig ${FLAGS} -lgmpnative -lc

clean:
	rm -rf build zig-cache

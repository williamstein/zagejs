simple.wasm: simple.zig
	zig build-lib -target wasm32-wasi -I. -L. simple.zig libgmp.a -lc -dynamic

run: simple.js simple.wasm
	node simple.js

run-native: simple.zig native.zig
	zig build-exe native.zig -I. -L. -lgmpnative -lc
	./native

run-native-custom: simple.zig native.zig
	zig build-exe native-custom-allocator.zig -I. -L. -lgmpnative -lc
	./native-custom-allocator

gmp-native-test: gmp.zig
	zig test gmp.zig -I. -L. -lgmpnative -lc

clean:
	rm -rf *.wasm *.o

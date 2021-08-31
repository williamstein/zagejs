const gmp = @cImport(@cInclude("gmp.h"));
const custom = @import("custom-gmp-allocator.zig");
const Integer = @import("gmp.zig").Integer;
const std = @import("std");

pub export fn f2() c_long {
    custom.initCustomGMPAllocator();

    var a: gmp.mpz_t = undefined;
    gmp.mpz_init(&a);
    _ = gmp.mpz_init_set_str(&a, "25", 10);
    var b: gmp.mpz_t = undefined;
    gmp.mpz_init(&b);
    _ = gmp.mpz_init_set_str(&b, "389", 10);
    var c: gmp.mpz_t = undefined;
    _ = gmp.mpz_init(&c);
    _ = gmp.mpz_add(&c, &a, &b);
    _ = gmp.gmp_printf("%s is an mpz %Zd\n", "here", &c);
    return gmp.mpz_get_si(&c);
}

pub export fn f() c_long {
    return _f() catch |err| {
        std.debug.print("Error in _f -- {}", .{err});
        return -1;
    };
}

fn _f() !c_long {
    custom.initCustomGMPAllocator();

    var a = Integer();
    try a.initSet(37);
    defer a.clear();

    var b = Integer();
    try b.initSetStr("389", 10);
    defer b.clear();

    var c = a.sub(b);
    defer c.clear();

    return c.get_c_long();
}

pub export fn add(a: i32, b: i32) c_long {
    var a2 = Integer();
    try a2.initSet(a);
    defer a2.clear();

    var b2 = Integer();
    try b2.initSet(b);
    defer b2.clear();

    var c = a2.add(b2);
    defer c.clear();
    return c.get_c_long();
}

pub export fn fromString(s: [*:0]const u8) void {
    std.debug.print("\nzig sees ='{s}'\n", .{s});
}

pub export fn isPseudoPrime(s: [*:0]const u8) i32 {
    std.debug.print("\nisPseudoPrime ='{s}'\n", .{s});
    var n = Integer();
    n.initSetStr(s, 10) catch |err| {
        std.debug.print("Error setting number -- {}\n", .{err});
        return 0;
    };
    defer n.clear();
    return n.primalityTest(15);
}

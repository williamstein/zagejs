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

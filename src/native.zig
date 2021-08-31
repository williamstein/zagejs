const simple = @import("simple.zig");
const std = @import("std");

pub fn main() void {
    std.debug.print("f() = {}\n", .{simple.f()});
}

const std = @import("std");

pub fn random(comptime T: anytype, allocator: std.mem.Allocator, limit: usize) ![]T {
    const rnd = std.rand.DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())).random();

    var array = try std.ArrayList(T).initCapacity(allocator, limit);

    switch (@typeInfo(T)) {
        .Int => {
            var i: usize = 0;
            while (i < limit) : (i += 1) {
                const item: T = rnd.intRangeAtMostBiased(T, std.math.minInt(T), @intCast(T, limit));
                array.appendAssumeCapacity(item);
            }
        },
        else => unreachable,
    }

    return array.toOwnedSlice();
}

pub fn sorted(comptime T: anytype, allocator: std.mem.Allocator, limit: usize) ![]T {
    var ret = try random(T, allocator, limit);

    std.sort.sort(T, ret, {}, comptime std.sort.asc(T));

    return ret;
}

pub fn reverse(comptime T: anytype, allocator: std.mem.Allocator, limit: usize) ![]T {
    var ret = try random(T, allocator, limit);

    std.sort.sort(T, ret, {}, comptime std.sort.desc(T));

    return ret;
}

pub fn ascSaw(comptime T: anytype, allocator: std.mem.Allocator, limit: usize) ![]T {
    const TEETH = 10;
    var ret = try random(T, allocator, limit);

    var offset: usize = 0;
    while (offset < TEETH) : (offset += 1) {
        const start = ret.len / TEETH * offset;
        std.sort.sort(T, ret[start .. start + ret.len / TEETH], {}, comptime std.sort.asc(T));
    }

    return ret;
}

pub fn descSaw(comptime T: anytype, allocator: std.mem.Allocator, limit: usize) ![]T {
    const TEETH = 10;
    var ret = try random(T, allocator, limit);

    var offset: usize = 0;
    while (offset < TEETH) : (offset += 1) {
        const start = ret.len / TEETH * offset;
        std.sort.sort(T, ret[start .. start + ret.len / TEETH], {}, comptime std.sort.desc(T));
    }

    return ret;
}

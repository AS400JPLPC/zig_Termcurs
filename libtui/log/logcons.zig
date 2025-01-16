///----------------------------
/// looger / historique traçage
/// console
///----------------------------

const std = @import("std");
const builtin = @import("builtin");
const root = @import("root");


pub fn customLog(
    comptime message_level: std.log.Level,
    comptime scope: @Type(.@"enum_literal"),
    comptime format: []const u8,
    args: anytype,

) void {
    if (builtin.os.tag == .freestanding)
        @compileError(
            \\freestanding targets do not have I/O configured;
            \\please provide at least an empty `log` function declaration
        );

    const level_txt = comptime message_level.asText();
    const scope_name = "(" ++ @tagName(scope) ++ ")";


    const stderr = std.io.getStdErr().writer();
    var bw = std.io.bufferedWriter(stderr);
    const writer = bw.writer();

    std.debug.lockStdErr();
    defer std.debug.unlockStdErr();
        nosuspend {
            writer.print("[" ++  level_txt ++ scope_name ++  "] " ++ format ++ "\n", args) catch return;
            bw.flush() catch return;
        }
    }

pub fn scoped(comptime scope: @Type(.@"enum_literal")) type {
    return struct {
        pub fn err(comptime format: []const u8, args: anytype) void {
            customLog(.err, scope, format, args);
        }

        pub fn warn(comptime format: []const u8, args: anytype) void {
            customLog(.warn, scope, format, args);
        }

        pub fn info(comptime format: []const u8, args: anytype) void {
            customLog(.info, scope, format, args);
        }

        pub fn debug(comptime format: []const u8, args: anytype) void {
            customLog(.debug, scope, format, args);
        }
    };
}


pub const default = scoped(.LOG);
pub const err = default.err;
pub const warn = default.warn;
pub const info = default.info;
pub const debug = default.debug;
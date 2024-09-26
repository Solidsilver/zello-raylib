const std = @import("std");
const math = std.math;
const raylib = @import("raylib.zig").raylib;
pub const ScreenSide = enum { left, right };

pub const Paddle = struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color,
    screenBounds: raylib.Vector2,

    pub fn Draw(self: *Paddle) void {
        raylib.DrawRectangleV(self.pos, self.size, self.color);
    }

    pub fn Move(self: *Paddle, dY: f32) void {
        self.pos.y += dY;
        self.pos.y = math.clamp(self.pos.y, 0, self.screenBounds.y - self.size.y);
    }

    pub fn GetBBox(self: *Paddle) raylib.Rectangle {
        return raylib.Rectangle{ .x = self.pos.x, .y = self.pos.y, .width = self.size.x, .height = self.size.y };
    }
};

pub fn New(side: ScreenSide, size: comptime_int, comptime windowX: i32, comptime windowY: i32) Paddle {
    var drawPosX: f32 = 0.0;
    const rect = raylib.Vector2{ .x = size * 2, .y = size * 10 };
    const bounds = raylib.Vector2{
        .x = @as(f32, windowX),
        .y = @as(f32, windowY),
    };
    if (side == ScreenSide.right) {
        drawPosX = bounds.x - rect.x;
    }
    return Paddle{ .pos = raylib.Vector2{ .x = drawPosX, .y = bounds.y / 2 }, .size = rect, .color = raylib.WHITE, .screenBounds = bounds };
}

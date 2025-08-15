const std = @import("std");
const math = std.math;
const raylib = @import("raylib.zig").raylib;

pub const Ball = struct {
    pos: raylib.Vector2,
    rad: f32,
    color: raylib.Color,
    screenBounds: raylib.Vector2,
    velocity: f32,
    dir: raylib.Vector2,
    isCollided: bool,

    pub fn Draw(self: *Ball) void {
        raylib.DrawCircleV(self.pos, self.rad, self.color);
    }

    pub fn Move(self: *Ball) void {
        const moveVec = raylib.Vector2Scale(self.dir, self.velocity);
        self.pos = raylib.Vector2Add(self.pos, moveVec);

        const topEdge = self.pos.y - self.rad;
        const btmEdge = self.pos.y + self.rad;

        if (topEdge <= 0) {
            self.dir.y *= -1;
            self.pos.y = self.rad - topEdge;
            self.velocity += 0.1;
        } else if (btmEdge >= self.screenBounds.y) {
            self.dir.y *= -1;
            self.pos.y = 2 * self.screenBounds.y - btmEdge - self.rad;
            self.velocity += 0.1;
        }
    }

    pub fn Bounce(self: *Ball) void {
        self.isCollided = true;
        self.dir.x *= -1;
        self.velocity += 0.1;
    }
    pub fn Reset(self: *Ball) void {
        self.pos.x = self.screenBounds.x / 2;
        self.pos.y = self.screenBounds.y / 2;
        self.velocity = 3;
        const startDir = raylib.Vector2{
            .x = @as(f32, @floatFromInt(raylib.GetRandomValue(-50, 50))) / 100,
            .y = @as(f32, @floatFromInt(raylib.GetRandomValue(-50, 50))) / 100,
        };
        self.dir = raylib.Vector2Normalize(startDir);
    }
};

pub fn New(size: comptime_int, comptime windowX: i32, comptime windowY: i32) Ball {
    const bounds = raylib.Vector2{
        .x = @as(f32, windowX),
        .y = @as(f32, windowY),
    };
    const startPos = raylib.Vector2{
        .x = bounds.x / 2.0,
        .y = bounds.y / 2.0,
    };
    const startDir = raylib.Vector2{
        .x = @as(f32, @floatFromInt(raylib.GetRandomValue(-50, 50))) / 100,
        .y = @as(f32, @floatFromInt(raylib.GetRandomValue(-50, 50))) / 100,
    };
    return Ball{ .pos = startPos, .rad = size, .color = raylib.WHITE, .screenBounds = bounds, .dir = raylib.Vector2Normalize(startDir), .velocity = 3, .isCollided = false };
}

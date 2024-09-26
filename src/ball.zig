const std = @import("std");
const math = std.math;
const raylib = @import("raylib.zig").raylib;
// const raymath = @import("raylib.zig").raymath;

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

        // const leftEdge = self.pos.x - self.rad;
        // const rightEdge = self.pos.x + self.rad;
        const topEdge = self.pos.y - self.rad;
        const btmEdge = self.pos.y + self.rad;

        // if (leftEdge <= 0) {
        //     self.dir.x *= -1;
        //     self.pos.x = self.rad - leftEdge;
        // } else if (rightEdge >= self.screenBounds.x) {
        //     self.dir.x *= -1;
        //     self.pos.x = 2 * self.screenBounds.x - rightEdge - self.rad;
        // }
        if (topEdge <= 0) {
            self.dir.y *= -1;
            self.pos.y = self.rad - topEdge;
        } else if (btmEdge >= self.screenBounds.y) {
            self.dir.y *= -1;
            self.pos.y = 2 * self.screenBounds.y - btmEdge - self.rad;
        }
    }

    pub fn Bounce(self: *Ball) void {
        // std.log.info("Ball is bouncing...", .{});
        self.isCollided = true;
        self.dir.x *= -1;
    }
    pub fn Reset(self: *Ball) void {
        // std.log.info("Ball is bouncing...", .{});
        // self.isCollided = true;
        self.pos.x = 250;
        self.pos.y = 250;
        self.velocity = 4;
    }
};

pub fn New(size: comptime_int, comptime windowX: i32, comptime windowY: i32) Ball {
    const bounds = raylib.Vector2{
        .x = @as(f32, windowX),
        .y = @as(f32, windowY),
    };
    return Ball{ .pos = raylib.Vector2{ .x = 200, .y = 200 }, .rad = size, .color = raylib.WHITE, .screenBounds = bounds, .dir = raylib.Vector2{ .x = -0.25, .y = -0.33 }, .velocity = 4, .isCollided = false };
}

const std = @import("std");
const math = std.math;
const paddle = @import("paddle.zig");
const ball = @import("ball.zig");
const raylib = @import("raylib.zig").raylib;

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    raylib.InitWindow(screenWidth, screenHeight, "RayZig Window :)");
    raylib.SetTargetFPS(120);
    defer raylib.CloseWindow();

    var p1 = paddle.New(paddle.ScreenSide.left, 10, screenWidth, screenHeight);
    var p2 = paddle.New(paddle.ScreenSide.right, 10, screenWidth, screenHeight);
    var b = ball.New(10, screenWidth, screenHeight);

    var fps: i32 = 0;
    // var fpsText := std.fmt.allocPrint(allocator: allocator, "{} fps", .{fps})
    var fps_text_buffer: [20]u8 = undefined; // Allocate enough space
    var count_text_buffer: [20]u8 = undefined; // Allocate enough space
    var pause = false;

    var restartCounter: i32 = 0;

    while (!raylib.WindowShouldClose()) {
        fps = raylib.GetFPS();
        const fps_text = std.fmt.bufPrint(&fps_text_buffer, "{d} fps", .{fps}) catch unreachable;
        fps_text_buffer[fps_text.len] = 0;

        // if (raylib.IsKeyDown(raylib.KEY_SPACE)) {
        if (!pause and restartCounter == 0) {
            if (raylib.CheckCollisionCircleRec(b.pos, b.rad, p1.GetBBox()) or raylib.CheckCollisionCircleRec(b.pos, b.rad, p2.GetBBox())) {
                if (!b.isCollided) {
                    b.Bounce();
                }
            } else {
                b.isCollided = false;
            }
            if (raylib.IsKeyDown(raylib.KEY_W)) {
                p1.Move(-2);
            }
            if (raylib.IsKeyDown(raylib.KEY_S)) {
                p1.Move(2);
            }
            if (raylib.IsKeyDown(raylib.KEY_UP)) {
                p2.Move(-2);
            }
            if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
                p2.Move(2);
            }
            b.Move();

            if (b.pos.x - b.rad < 0 or b.pos.x + b.rad > screenWidth) {
                restartCounter = 1;
                b.Reset();
            }
        } else if (!pause) {
            if (restartCounter > 0) {
                restartCounter += 1;
                const count_text = std.fmt.bufPrint(&count_text_buffer, "Restarting... {d}", .{500 - restartCounter}) catch unreachable;
                count_text_buffer[count_text.len] = 0;
                raylib.DrawText(count_text.ptr, (screenWidth / 2), 100, 20, raylib.LIGHTGRAY);
            }
            if (restartCounter > 500) {
                restartCounter = 0;
            }
        }
        if (pause) {
            raylib.DrawText("Paused", (screenWidth / 2) - 160, 100, 100, raylib.LIGHTGRAY);
        }
        if (raylib.GetKeyPressed() == raylib.KEY_SPACE) {
            pause = !pause;
        }

        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.BLACK);
        const fpsTextLen: i32 = @intCast(fps_text.len);
        raylib.DrawText(fps_text.ptr, (screenWidth / 2) - (fpsTextLen * 6), 2, 20, raylib.LIGHTGRAY);
        b.Draw();
        p1.Draw();
        p2.Draw();
        raylib.EndDrawing();
    }
}

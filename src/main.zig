const std = @import("std");
const math = std.math;
const paddle = @import("paddle.zig");
const ball = @import("ball.zig");
const raylib = @import("raylib.zig").raylib;

pub fn main() !void {
    const screenWidth = 1200;
    const screenHeight = 800;

    raylib.InitWindow(screenWidth, screenHeight, "RayZig Window :)");
    raylib.SetTargetFPS(120);
    defer raylib.CloseWindow();

    var p1 = paddle.New(paddle.ScreenSide.left, 10, screenWidth, screenHeight);
    var p2 = paddle.New(paddle.ScreenSide.right, 10, screenWidth, screenHeight);
    var b = ball.New(10, screenWidth, screenHeight);

    var scoreP1: i32 = 0;
    var scoreP2: i32 = 0;

    var count_text_buffer: [20]u8 = undefined; // Allocate enough space
    var score_buffer: [20]u8 = undefined; // Allocate enough space
    var pause = false;

    var restartCounter: i32 = 0;

    while (!raylib.WindowShouldClose()) {

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
                p1.Move(-3);
            }
            if (raylib.IsKeyDown(raylib.KEY_S)) {
                p1.Move(3);
            }
            if (raylib.IsKeyDown(raylib.KEY_UP)) {
                p2.Move(-3);
            }
            if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
                p2.Move(3);
            }
            b.Move();
            // b.velocity += 0.01;

            if (b.pos.x - b.rad < 0) {
                scoreP2 += 1;
                restartCounter = 1;
                b.Reset();
            } else if (b.pos.x + b.rad > screenWidth) {
                scoreP1 += 1;
                restartCounter = 1;
                b.Reset();
            }
        } else if (!pause) {
            if (restartCounter > 0) {
                restartCounter += 1;
                const count_text = std.fmt.bufPrint(&count_text_buffer, "Restarting... {d}", .{@divTrunc(500 - restartCounter, 100) + 1}) catch unreachable;
                count_text_buffer[count_text.len] = 0;
                const txtLen: i32 = @intCast(count_text_buffer.len);
                raylib.DrawText(count_text.ptr, (screenWidth / 2) - (txtLen * 4), 100, 20, raylib.LIGHTGRAY);
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
        raylib.DrawFPS(5, 5);
        var scoreText = std.fmt.bufPrint(&score_buffer, "{d}", .{scoreP1}) catch unreachable;
        score_buffer[scoreText.len] = 0;
        raylib.DrawText(scoreText.ptr, (screenWidth / 4), 100, 70, raylib.LIGHTGRAY);
        scoreText = std.fmt.bufPrint(&score_buffer, "{d}", .{scoreP2}) catch unreachable;
        score_buffer[scoreText.len] = 0;
        raylib.DrawText(scoreText.ptr, (screenWidth / 4) * 3, 100, 70, raylib.LIGHTGRAY);
        b.Draw();
        p1.Draw();
        p2.Draw();
        raylib.EndDrawing();
    }
}

const std = @import("std");
const math = std.math;
const raylib = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    raylib.InitWindow(screenWidth, screenHeight, "RayZig Window :)");
    raylib.SetTargetFPS(120);
    defer raylib.CloseWindow();

    var ballPos = raylib.Vector2{ .x = @as(f32, screenWidth) / 2, .y = @as(f32, screenHeight) / 2 };
    var ballRad: f32 = 10.0;

    while (!raylib.WindowShouldClose()) {
        if (raylib.IsKeyDown(raylib.KEY_RIGHT)) {
            ballPos.x += 2.0;
        }
        if (raylib.IsKeyDown(raylib.KEY_LEFT)) {
            ballPos.x -= 2.0;
        }
        if (raylib.IsKeyDown(raylib.KEY_UP)) {
            ballPos.y -= 2.0;
        }
        if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
            ballPos.y += 2.0;
        }
        if (raylib.IsKeyDown(raylib.KEY_P)) {
            ballRad += 2.0;
        }
        if (raylib.IsKeyDown(raylib.KEY_O)) {
            ballRad -= 2.0;
        }

        ballRad = math.clamp(ballRad, 4, @min(screenWidth, screenHeight) / 2);
        ballPos.x = math.clamp(ballPos.x, ballRad, screenWidth - ballRad);
        ballPos.y = math.clamp(ballPos.y, ballRad, screenHeight - ballRad);

        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.BLACK);
        raylib.DrawText("Hello Window from Zig!", 10, screenWidth / 2, 20, raylib.LIGHTGRAY);
        raylib.DrawCircleV(ballPos, ballRad, raylib.MAROON);
        raylib.EndDrawing();
    }
}

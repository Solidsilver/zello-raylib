const std = @import("std");
const math = std.math;
const r = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    r.InitWindow(screenWidth, screenHeight, "RayZig Window :)");
    r.SetTargetFPS(120);
    defer r.CloseWindow();

    var ballPos = r.Vector2{ .x = @as(f32, screenWidth) / 2, .y = @as(f32, screenHeight) / 2 };
    var ballRad: f32 = 10.0;

    while (!r.WindowShouldClose()) {
        if (r.IsKeyDown(r.KEY_RIGHT)) {
            ballPos.x += 2.0;
        }
        if (r.IsKeyDown(r.KEY_LEFT)) {
            ballPos.x -= 2.0;
        }
        if (r.IsKeyDown(r.KEY_UP)) {
            ballPos.y -= 2.0;
        }
        if (r.IsKeyDown(r.KEY_DOWN)) {
            ballPos.y += 2.0;
        }
        if (r.IsKeyDown(r.KEY_P)) {
            ballRad += 2.0;
        }
        if (r.IsKeyDown(r.KEY_O)) {
            ballRad -= 2.0;
        }

        ballRad = math.clamp(ballRad, 4, @min(screenWidth, screenHeight) / 2);
        ballPos.x = math.clamp(ballPos.x, ballRad, screenWidth - ballRad);
        ballPos.y = math.clamp(ballPos.y, ballRad, screenHeight - ballRad);

        r.BeginDrawing();
        r.ClearBackground(r.BLACK);
        r.DrawText("Hello Window from Zig!", 10, screenWidth / 2, 20, r.LIGHTGRAY);
        r.DrawCircleV(ballPos, ballRad, r.MAROON);
        r.EndDrawing();
    }
}

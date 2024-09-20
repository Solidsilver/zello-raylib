const std = @import("std");
const math = std.math;
const paddle = @import("paddle.zig");
const raylib = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    raylib.InitWindow(screenWidth, screenHeight, "RayZig Window :)");
    raylib.SetTargetFPS(120);
    defer raylib.CloseWindow();

    var p1Pos = raylib.Vector2{ .x = @as(f32, screenWidth) / 2, .y = @as(f32, screenHeight) / 2 };
    var ballRad: f32 = 10.0;
    var p1 = paddle.New(paddle.ScreenSide.left, 10, screenWidth, screenHeight);
    var p2 = paddle.New(paddle.ScreenSide.right, 10, screenWidth, screenHeight);

    var fps: i32 = 0;
    // var fpsText := std.fmt.allocPrint(allocator: allocator, "{} fps", .{fps})
    var fps_text_buffer: [20]u8 = undefined; // Allocate enough space

    while (!raylib.WindowShouldClose()) {
        fps = raylib.GetFPS();
        const fps_text = std.fmt.bufPrint(&fps_text_buffer, "{d} fps", .{fps}) catch unreachable;
        fps_text_buffer[fps_text.len] = 0;

        if (raylib.IsKeyDown(raylib.KEY_UP)) {
            p1.Move(-2);
        }
        if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
            p1.Move(2);
        }
        // const keyDown = raylib.GetKeyPressed();
        // switch (keyDown) {
        //     raylib.KEY_UP => {
        //         p1.Move(-2);
        //     },
        //     raylib.KEY_DOWN => {
        //         p1.Move(2);
        //     },
        //     else => {},
        // }
        // if (raylib.IsKeyDown(raylib.KEY_P)) {
        //     ballRad += 2.0;
        // }
        // if (raylib.IsKeyDown(raylib.KEY_O)) {
        //     ballRad -= 2.0;
        // }

        ballRad = math.clamp(ballRad, 4, @min(screenWidth, screenHeight) / 2);
        p1Pos.x = math.clamp(p1Pos.x, ballRad, screenWidth - ballRad);
        p1Pos.y = math.clamp(p1Pos.y, ballRad, screenHeight - ballRad);

        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.BLACK);
        const fpsTextLen: i32 = @intCast(fps_text.len);
        raylib.DrawText(fps_text.ptr, (screenWidth / 2) - (fpsTextLen * 6), 2, 20, raylib.LIGHTGRAY);
        raylib.DrawCircleV(p1Pos, ballRad, raylib.MAROON);
        p1.Draw();
        p2.Draw();
        raylib.EndDrawing();
    }
}

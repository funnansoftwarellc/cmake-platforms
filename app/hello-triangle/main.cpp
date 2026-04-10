#include <print>

#include <raylib.h>

auto main() -> int
{
    InitWindow(800, 600, "Hello, Triangle");

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(GRAY);
        DrawTriangle(Vector2{400, 100}, Vector2{300, 300}, Vector2{500, 300}, ORANGE);
        EndDrawing();
    }

    CloseWindow();

    return EXIT_SUCCESS;
}
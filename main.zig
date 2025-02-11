const rl = @import("raylib");
const std = @import("std");

const triangle = struct { p1: rl.Vector3, p2: rl.Vector3, p3: rl.Vector3, color: rl.Color };

// Draw the 3 golden rectangles that make up the base icosahedron
fn drawGoldenRectangle(icosaPointArray: *const [12]rl.Vector3) void {
    // xy rectangle
    rl.drawLine3D(icosaPointArray[0], icosaPointArray[1], rl.Color.green); // xy1 -> xy2
    rl.drawLine3D(icosaPointArray[1], icosaPointArray[2], rl.Color.green); // xy2 -> xy3
    rl.drawLine3D(icosaPointArray[2], icosaPointArray[3], rl.Color.green); // xy3 -> xy4
    rl.drawLine3D(icosaPointArray[3], icosaPointArray[0], rl.Color.green); // xy4 -> xy1
    // xz rectangle
    rl.drawLine3D(icosaPointArray[4], icosaPointArray[5], rl.Color.red); // xz1 -> xz2
    rl.drawLine3D(icosaPointArray[5], icosaPointArray[6], rl.Color.red); // xz2 -> xz3
    rl.drawLine3D(icosaPointArray[6], icosaPointArray[7], rl.Color.red); // xz3 -> xz4
    rl.drawLine3D(icosaPointArray[7], icosaPointArray[4], rl.Color.red); // xz4 -> xz1
    // zy rectangle
    rl.drawLine3D(icosaPointArray[8], icosaPointArray[9], rl.Color.blue); // zy1 -> zy2
    rl.drawLine3D(icosaPointArray[9], icosaPointArray[10], rl.Color.blue); // zy2 -> zy3
    rl.drawLine3D(icosaPointArray[10], icosaPointArray[11], rl.Color.blue); // zy3 -> zy4
    rl.drawLine3D(icosaPointArray[11], icosaPointArray[8], rl.Color.blue); // zy4 -> zy1
}

// Draw the 20 triangles that make up the base icosahedron
fn drawIcosahedron(icosaTriArray: *const [20]triangle) void {
    for (icosaTriArray) |tri| {
        rl.drawTriangle3D(tri.p1, tri.p2, tri.p3, tri.color);
    }
}

// Draw camera hotkey help tooltip
fn drawCameraTooltip() void {
    const fontSize = 20;
    const tooltipWidth = 365;
    const tooltipHeight = 160;
    rl.drawRectangle(10, 10, tooltipWidth, tooltipHeight, rl.Color.fade(rl.Color.light_gray, 0.5));
    rl.drawRectangleLines(10, 10, tooltipWidth, tooltipHeight, rl.Color.black);
    rl.drawText("Controls:", 20, 20, fontSize, rl.Color.black);
    rl.drawText("- Z to snap to (0, 0, 0)", 40, 40, fontSize, rl.Color.dark_gray);
    rl.drawText("- WASD to move", 40, 60, fontSize, rl.Color.dark_gray);
    rl.drawText("- ARROW KEYS to pan (slowly)", 40, 80, fontSize, rl.Color.dark_gray);
    rl.drawText("- Q or E to rotate (slowly)", 40, 100, fontSize, rl.Color.dark_gray);
    rl.drawText("- MOUSE WHEEL to Zoom in-out", 40, 120, fontSize, rl.Color.dark_gray);
    rl.drawText("- F to toggle fullscreen", 40, 140, fontSize, rl.Color.dark_gray);
}

fn bisectVector(v1: rl.Vector3, v2: rl.Vector3) rl.Vector3 {
    return (rl.Vector3.subtract(v1, v2) / 2);
}

fn magnitudeVector(v1: rl.Vector3) rl.Vector3 {
    return std.math.sqrt(v1.x * v1.x + v1.y * v1.y + v1.z * v1.z);
}

//Project onto sphere
fn projectVector(v1: rl.Vector3, v2: rl.Vector3) rl.Vector3 {
    return (v1 * magnitudeVector(v2) / magnitudeVector(v1));
}

//fn subdivide(icosaPointArray: *const [12]rl.Vector3) void {
//    for (icosaPointArray) |point| {
//
//    }
//}

pub fn main() anyerror!void {
    // Golden ratio = (1 + sqrt(5))/2
    const phi = 1.6180339887498948482045868343656381177203091798057628621;

    const screenWidth = 1280;
    const screenHeight = 720;
    const scale = 2;

    rl.initWindow(screenWidth, screenHeight, "hexary");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setMousePosition(0, 0);
    rl.disableCursor();

    var camera = rl.Camera{
        .position = rl.Vector3.init(10, 10, 10),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45,
        .projection = .perspective,
    };

    //Icosahedron coords
    const icosaPointArray = [12]rl.Vector3{
        rl.Vector3.scale(rl.Vector3.init(1, phi, 0), scale), //xy1
        rl.Vector3.scale(rl.Vector3.init(1, -phi, 0), scale), //xy2
        rl.Vector3.scale(rl.Vector3.init(-1, -phi, 0), scale), //xy3
        rl.Vector3.scale(rl.Vector3.init(-1, phi, 0), scale), //xy4
        rl.Vector3.scale(rl.Vector3.init(phi, 0, 1), scale), //xz1
        rl.Vector3.scale(rl.Vector3.init(phi, 0, -1), scale), //xz2
        rl.Vector3.scale(rl.Vector3.init(-phi, 0, -1), scale), //xz3
        rl.Vector3.scale(rl.Vector3.init(-phi, 0, 1), scale), //xz4
        rl.Vector3.scale(rl.Vector3.init(0, 1, phi), scale), //zy1
        rl.Vector3.scale(rl.Vector3.init(0, 1, -phi), scale), //zy2
        rl.Vector3.scale(rl.Vector3.init(0, -1, -phi), scale), //zy3
        rl.Vector3.scale(rl.Vector3.init(0, -1, phi), scale), //zy4
    };
    //Icosahedron triangles
    const icosaTriArray = [20]triangle{
        triangle{ .p1 = icosaPointArray[0], .p2 = icosaPointArray[5], .p3 = icosaPointArray[9], .color = rl.Color.yellow },
        triangle{ .p1 = icosaPointArray[0], .p2 = icosaPointArray[9], .p3 = icosaPointArray[3], .color = rl.Color.white },
        triangle{ .p1 = icosaPointArray[0], .p2 = icosaPointArray[3], .p3 = icosaPointArray[8], .color = rl.Color.beige },
        triangle{ .p1 = icosaPointArray[0], .p2 = icosaPointArray[8], .p3 = icosaPointArray[4], .color = rl.Color.pink },
        triangle{ .p1 = icosaPointArray[0], .p2 = icosaPointArray[4], .p3 = icosaPointArray[5], .color = rl.Color.orange },
        triangle{ .p1 = icosaPointArray[2], .p2 = icosaPointArray[6], .p3 = icosaPointArray[10], .color = rl.Color.green },
        triangle{ .p1 = icosaPointArray[2], .p2 = icosaPointArray[10], .p3 = icosaPointArray[1], .color = rl.Color.gold },
        triangle{ .p1 = icosaPointArray[2], .p2 = icosaPointArray[1], .p3 = icosaPointArray[11], .color = rl.Color.maroon },
        triangle{ .p1 = icosaPointArray[2], .p2 = icosaPointArray[11], .p3 = icosaPointArray[7], .color = rl.Color.black },
        triangle{ .p1 = icosaPointArray[2], .p2 = icosaPointArray[7], .p3 = icosaPointArray[6], .color = rl.Color.lime },
        triangle{ .p1 = icosaPointArray[9], .p2 = icosaPointArray[6], .p3 = icosaPointArray[3], .color = rl.Color.sky_blue },
        triangle{ .p1 = icosaPointArray[3], .p2 = icosaPointArray[6], .p3 = icosaPointArray[7], .color = rl.Color.violet },
        triangle{ .p1 = icosaPointArray[3], .p2 = icosaPointArray[7], .p3 = icosaPointArray[8], .color = rl.Color.dark_purple },
        triangle{ .p1 = icosaPointArray[8], .p2 = icosaPointArray[7], .p3 = icosaPointArray[11], .color = rl.Color.dark_brown },
        triangle{ .p1 = icosaPointArray[8], .p2 = icosaPointArray[11], .p3 = icosaPointArray[4], .color = rl.Color.light_gray },
        triangle{ .p1 = icosaPointArray[4], .p2 = icosaPointArray[11], .p3 = icosaPointArray[1], .color = rl.Color.red },
        triangle{ .p1 = icosaPointArray[4], .p2 = icosaPointArray[1], .p3 = icosaPointArray[5], .color = rl.Color.dark_green },
        triangle{ .p1 = icosaPointArray[5], .p2 = icosaPointArray[1], .p3 = icosaPointArray[10], .color = rl.Color.blue },
        triangle{ .p1 = icosaPointArray[10], .p2 = icosaPointArray[9], .p3 = icosaPointArray[5], .color = rl.Color.dark_blue },
        triangle{ .p1 = icosaPointArray[9], .p2 = icosaPointArray[10], .p3 = icosaPointArray[6], .color = rl.Color.magenta },
    };

    //const triNeighbors = [20][3]triangle{
    // Assign initial neighbors
    //
    //c# neighbor code to convert
    //output[0].AssignNeighbors(output[1], output[4], output[18]);
    //output[1].AssignNeighbors(output[2], output[0], output[10]);
    //output[2].AssignNeighbors(output[1], output[12], output[3]);
    //output[3].AssignNeighbors(output[2], output[14], output[4]);
    //output[4].AssignNeighbors(output[3], output[16], output[0]);
    //output[5].AssignNeighbors(output[19], output[6], output[9]);
    //output[6].AssignNeighbors(output[5], output[17], output[7]);
    //output[7].AssignNeighbors(output[6], output[15], output[8]);
    //output[8].AssignNeighbors(output[7], output[13], output[9]);
    //output[9].AssignNeighbors(output[8], output[11], output[5]);
    //output[10].AssignNeighbors(output[1], output[19], output[11]);
    //output[11].AssignNeighbors(output[10], output[9], output[12]);
    //output[12].AssignNeighbors(output[11], output[13], output[2]);
    //output[13].AssignNeighbors(output[12], output[8], output[14]);
    //output[14].AssignNeighbors(output[13], output[15], output[3]);
    //output[15].AssignNeighbors(output[14], output[7], output[16]);
    //output[16].AssignNeighbors(output[15], output[17], output[4]);
    //output[17].AssignNeighbors(output[16], output[6], output[18]);
    //output[18].AssignNeighbors(output[17], output[19], output[0]);
    //output[19].AssignNeighbors(output[18], output[5], output[10]);
    //}

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //---------------------------------------------------------------------
        camera.update(.free);

        if (rl.isKeyPressed(.z)) {
            camera.target = rl.Vector3.init(0, 0, 0);
        }
        if (rl.isKeyPressed(.f)) {
            rl.toggleFullscreen();
        }

        // Draw
        //-----------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.dark_gray);

        {
            camera.begin();
            defer camera.end();

            //drawGoldenRectangle(&icosaPointArray);
            drawIcosahedron(&icosaTriArray);
        }
        drawCameraTooltip();
    }
}

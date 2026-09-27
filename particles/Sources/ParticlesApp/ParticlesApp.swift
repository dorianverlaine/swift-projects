import AppKit
import ParticlesCore
import SwiftUI

@main
struct ParticlesApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate()
    }

    var body: some Scene {
        WindowGroup("Particles") {
            SimulatorView()
        }
    }
}

struct SimulatorView: View {
    @State private var world = Grid(width: 120, height: 90)
    @State private var brush: Flavor = .sand
    @State private var brushRadius = 2.0
    @State private var running = true

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                let side = min(geometry.size.width / CGFloat(world.width),
                               geometry.size.height / CGFloat(world.height))
                Canvas { context, size in
                    context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.black))
                    for y in 0..<world.height {
                        for x in 0..<world.width where world[x, y].flavor != .empty {
                            let cell = CGRect(x: CGFloat(x) * side, y: CGFloat(y) * side, width: side, height: side)
                            context.fill(Path(cell), with: .color(Color(world[x, y].color)))
                        }
                    }
                }
                .gesture(DragGesture(minimumDistance: 0).onChanged { drag in
                    paint(at: drag.location, side: side)
                })
            }
            controls
        }
        .frame(minWidth: 720, minHeight: 600)
        .task(id: running) {
            var dice = RandomDice()
            while running {
                try? await Task.sleep(for: .milliseconds(33))
                world.tick(dice: &dice)
            }
        }
    }

    // Task 7
    /// Places the brush's flavor in every cell within `brushRadius` cells of
    /// the point, a disk centered on the cell under the pointer.
    private func paint(at point: CGPoint, side: CGFloat) {
        // Your code here. `side` is the width of one cell on screen.
    }

    private var controls: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                ForEach(Flavor.allCases, id: \.self) { flavor in
                    Button {
                        brush = flavor
                    } label: {
                        Circle()
                            .fill(Color(flavor.color))
                            .frame(width: 18, height: 18)
                            .overlay(Circle().stroke(.white, lineWidth: brush == flavor ? 2 : 0))
                    }
                    .buttonStyle(.glass)
                    .help(String(describing: flavor).capitalized)
                }
                Slider(value: $brushRadius, in: 0...6, step: 1) { Text("Brush") }
                    .frame(width: 110)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .glassEffect(.regular.interactive(), in: .capsule)
                Button(running ? "Pause" : "Play", systemImage: running ? "pause.fill" : "play.fill") {
                    running.toggle()
                }
                .buttonStyle(.glassProminent)
                Button("Clear", systemImage: "trash") {
                    world = Grid(width: world.width, height: world.height)
                }
                .buttonStyle(.glass)
            }
        }
        .padding()
    }
}

extension Color {
    init(_ rgb: RGB) {
        self.init(red: Double(rgb.red) / 255, green: Double(rgb.green) / 255, blue: Double(rgb.blue) / 255)
    }
}

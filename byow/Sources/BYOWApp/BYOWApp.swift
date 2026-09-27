// Provided. Run it once your core passes the tests:
//     swift run -c release BYOWApp
// Then make it yours: see “Ambition” on the project page.

import AppKit
import BYOWCore
import SwiftUI

@main
struct BYOWApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate()
    }

    var body: some Scene {
        WindowGroup("Build Your Own World") {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var game: Game?
    @State private var message: String?

    var body: some View {
        Group {
            if let game {
                GameView(game: Binding { game } set: { self.game = $0 }, quit: saveAndQuit)
            } else {
                MenuView(message: message, start: start, load: load)
            }
        }
        .frame(minWidth: 760, minHeight: 480)
    }

    private func start(seed: UInt64) {
        game = Game(seed: seed)
        message = nil
    }

    private func load() {
        do {
            if let saved = try FileStore.standard.load() {
                game = saved
            } else {
                message = "No saved game yet."
            }
        } catch {
            message = "Could not load: \(error.localizedDescription)"
        }
    }

    private func saveAndQuit() {
        guard let game else { return }
        do {
            try FileStore.standard.save(game)
            message = "Saved. Load to continue where you left off."
        } catch {
            message = "Could not save: \(error.localizedDescription)"
        }
        self.game = nil
    }
}

struct MenuView: View {
    let message: String?
    let start: (UInt64) -> Void
    let load: () -> Void
    @State private var seedText = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Build Your Own World")
                .font(.largeTitle.bold())
            TextField("Seed", text: $seedText)
                .textFieldStyle(.plain)
                .font(.title3.monospacedDigit())
                .multilineTextAlignment(.center)
                .frame(width: 220)
                .padding(.vertical, 8)
                .glassEffect(.regular.interactive(), in: .capsule)
                .onSubmit(newWorld)
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    Button("New world", systemImage: "globe.americas.fill", action: newWorld)
                        .buttonStyle(.glassProminent)
                        .disabled(UInt64(seedText) == nil)
                    Button("Random", systemImage: "dice") {
                        seedText = String(UInt64.random(in: 0...999_999))
                    }
                    .buttonStyle(.glass)
                    Button("Load", systemImage: "tray.and.arrow.up", action: load)
                        .buttonStyle(.glass)
                }
            }
            if let message {
                Text(message).foregroundStyle(.secondary)
            }
        }
        .padding(40)
    }

    private func newWorld() {
        if let seed = UInt64(seedText) { start(seed) }
    }
}

struct GameView: View {
    @Binding var game: Game
    let quit: () -> Void
    @State private var hovered: Position?
    @State private var colon = false
    @FocusState private var focused: Bool

    var body: some View {
        GeometryReader { geometry in
            let world = game.world
            let side = min(geometry.size.width / CGFloat(world.width),
                           geometry.size.height / CGFloat(world.height))
            Canvas { context, _ in
                for row in 0..<world.height {
                    for column in 0..<world.width {
                        let tile = world[row, column]
                        guard tile != .nothing else { continue }
                        let rect = CGRect(x: CGFloat(column) * side, y: CGFloat(row) * side,
                                          width: side, height: side)
                        context.fill(Path(rect.insetBy(dx: 0.5, dy: 0.5)), with: .color(tile.color))
                    }
                }
                let avatar = CGRect(x: CGFloat(game.avatar.column) * side, y: CGFloat(game.avatar.row) * side,
                                    width: side, height: side)
                context.fill(Path(ellipseIn: avatar.insetBy(dx: side * 0.15, dy: side * 0.15)),
                             with: .color(.yellow))
            }
            .frame(width: side * CGFloat(world.width), height: side * CGFloat(world.height))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onContinuousHover { phase in
                guard case .active(let point) = phase else { return hovered = nil }
                let origin = CGPoint(x: (geometry.size.width - side * CGFloat(world.width)) / 2,
                                     y: (geometry.size.height - side * CGFloat(world.height)) / 2)
                let p = Position(row: Int((point.y - origin.y) / side), column: Int((point.x - origin.x) / side))
                hovered = world.contains(p) ? p : nil
            }
        }
        .background(.black)
        .overlay(alignment: .top) { hud.padding() }
        .focusable()
        .focusEffectDisabled()
        .focused($focused)
        .onAppear { focused = true }
        .onKeyPress(phases: .down) { press in
            handle(press.characters.lowercased()) ? .handled : .ignored
        }
    }

    private var hud: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                Label(hovered.map { "\(game.world[$0].name) \($0)" } ?? "—", systemImage: "scope")
                    .frame(minWidth: 150, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(in: .capsule)
                Text(verbatim: "seed \(game.seed) · \(game.steps) steps\(colon ? " · :" : "")")
                    .monospacedDigit()
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(in: .capsule)
                Button("Save and quit", systemImage: "square.and.arrow.down", action: quit)
                    .buttonStyle(.glass)
            }
        }
    }

    /// The same rules as `interact(withInput:store:)` during a game.
    private func handle(_ key: String) -> Bool {
        guard let character = key.first, key.count == 1 else { return false }
        if colon && character == "q" {
            quit()
            return true
        }
        colon = character == ":"
        if let move = Move(rawValue: character) {
            game.apply(move)
        }
        return true
    }
}

extension Tile {
    var color: Color {
        switch self {
        case .nothing: .clear
        case .floor: Color(white: 0.28)
        case .wall: Color(red: 0.55, green: 0.36, blue: 0.24)
        }
    }
}

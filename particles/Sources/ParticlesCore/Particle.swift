/// The kinds of particle.
public enum Flavor: CaseIterable, Sendable {
    case empty, sand, barrier, water, fountain, plant, fire, flower
}

/// A color, as red, green, and blue components from 0 to 255.
public struct RGB: Equatable, Sendable {
    public let red: Int
    public let green: Int
    public let blue: Int

    public init(_ red: Int, _ green: Int, _ blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

extension Flavor {
    // Task 1
    /// The color a particle of this flavor is drawn in.
    public var color: RGB {
        RGB(0, 0, 0) // Replace this line.
    }

    /// Whether fire can spread to a particle of this flavor. (Provided.)
    public var isFlammable: Bool {
        self == .plant || self == .flower
    }
}

/// One cell of the world.
public struct Particle: Equatable, Sendable {
    public var flavor: Flavor
    /// How many more ticks the particle lasts; -1 means it lasts forever.
    public var lifespan: Int

    // Task 1
    /// A new particle. Fire lasts 10 ticks; everything else lasts forever.
    public init(_ flavor: Flavor) {
        self.flavor = flavor
        lifespan = -1 // Replace this line.
    }

    // Task 1
    /// The particle's color: its flavor's color, except that fire fades as
    /// it burns out, its red and green scaled by the fraction of its life left.
    public var color: RGB {
        RGB(0, 0, 0) // Replace this line.
    }
}

// Provided. Do not change this file.

/// A source of randomness. The simulation asks a `Dice` for every random
/// decision, so tests can pass one whose answers are fixed.
public protocol Dice {
    /// True with the given probability, from 0 (never) to 1 (always).
    mutating func chance(_ probability: Double) -> Bool

    /// A random integer from 0 up to, but not including, `count`.
    mutating func pick(_ count: Int) -> Int
}

/// Real randomness, for the app.
public struct RandomDice: Dice {
    private var generator = SystemRandomNumberGenerator()

    public init() {}

    public mutating func chance(_ probability: Double) -> Bool {
        Double.random(in: 0..<1, using: &generator) < probability
    }

    public mutating func pick(_ count: Int) -> Int {
        Int.random(in: 0..<count, using: &generator)
    }
}

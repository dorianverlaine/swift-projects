// Provided. Do not change this file: the tests depend on its exact sequence.

/// A seedable pseudorandom number generator (the SplitMix64 algorithm). The
/// same seed always produces the same sequence, on every platform.
///
/// Every random choice in world generation must use one of these, passed
/// along as `inout`, never the system generator.
public struct SplitMix64: RandomNumberGenerator, Sendable {
    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

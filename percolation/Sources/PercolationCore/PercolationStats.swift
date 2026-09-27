// Provided. Read it: it is Lesson 22's task groups at work.

/// The result of a Monte Carlo estimate of the percolation threshold.
public struct ThresholdEstimate: Sendable {
    /// The fraction of open sites at which each trial first percolated.
    public let fractions: [Double]

    public var mean: Double {
        fractions.reduce(0, +) / Double(fractions.count)
    }

    public var standardDeviation: Double {
        guard fractions.count > 1 else { return .nan }
        let m = mean
        let variance = fractions.map { ($0 - m) * ($0 - m) }.reduce(0, +) / Double(fractions.count - 1)
        return variance.squareRoot()
    }

    /// A 95% confidence interval for the threshold.
    public var confidenceInterval: ClosedRange<Double> {
        let margin = 1.96 * standardDeviation / Double(fractions.count).squareRoot()
        return (mean - margin)...(mean + margin)
    }
}

public enum PercolationStats {
    /// Opens random blocked sites of an empty grid until it percolates, and
    /// returns the fraction of sites that were open.
    public static func trial(size: Int, using generator: inout some RandomNumberGenerator) -> Double {
        var grid = Percolation(size: size)
        var blocked = Array(0..<(size * size))
        blocked.shuffle(using: &generator)
        while !grid.percolates(), let site = blocked.popLast() {
            grid.open(row: site / size, column: site % size)
        }
        return Double(grid.openSites) / Double(size * size)
    }

    /// Runs `trials` independent trials concurrently, one child task each.
    public static func estimate(size: Int, trials: Int) async -> ThresholdEstimate {
        precondition(size > 0 && trials > 0)
        let fractions = await withTaskGroup(of: Double.self) { group in
            for _ in 0..<trials {
                group.addTask {
                    var generator = SystemRandomNumberGenerator()
                    return trial(size: size, using: &generator)
                }
            }
            var fractions: [Double] = []
            for await fraction in group {
                fractions.append(fraction)
            }
            return fractions
        }
        return ThresholdEstimate(fractions: fractions)
    }
}

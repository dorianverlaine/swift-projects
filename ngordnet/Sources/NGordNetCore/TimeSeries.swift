/// Values indexed by year, such as how often a word was used each year.
public struct TimeSeries: Equatable, Sendable {
    public static let minYear = 1400
    public static let maxYear = 2100

    /// The values, by year. Years without data are absent. (Provided.)
    public private(set) var data: [Int: Double] = [:]

    public init() {}

    // Task 1
    /// A copy of `other` with only the years from `start` through `end`.
    /// Empty if `start` is after `end`.
    public init(copying other: TimeSeries, from start: Int, through end: Int) {
        // Your code here.
    }

    /// Provided.
    public subscript(year: Int) -> Double? {
        get { data[year] }
        set { data[year] = newValue }
    }

    // Task 1
    /// The years with data, in increasing order.
    public var years: [Int] {
        [] // Replace this line.
    }

    // Task 1
    /// The values, in the same order as `years`.
    public var values: [Double] {
        [] // Replace this line.
    }

    // Task 1
    /// The sum of two series, year by year. A year missing from one series
    /// counts as 0 there; a year missing from both is missing from the sum.
    public func plus(_ other: TimeSeries) -> TimeSeries {
        TimeSeries() // Replace this line.
    }

    // Task 1
    /// This series divided by another, year by year, for the years of this
    /// series. Every year of this series must be present in `other`: check it
    /// with a precondition.
    public func dividedBy(_ other: TimeSeries) -> TimeSeries {
        TimeSeries() // Replace this line.
    }
}

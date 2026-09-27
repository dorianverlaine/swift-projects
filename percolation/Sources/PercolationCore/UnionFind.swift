// Provided. Do not change this file.

/// Disjoint sets of the items 0 to count - 1: weighted quick union, from
/// Lesson 35. `find` does not compress paths, so it does not change the
/// structure, and `isConnected` can be used from code that only reads, such
/// as a SwiftUI view. Every operation takes O(log N) time.
public struct UnionFind: Sendable {
    private var parent: [Int]
    private var size: [Int]

    public init(count: Int) {
        parent = Array(0..<count)
        size = Array(repeating: 1, count: count)
    }

    public func find(_ p: Int) -> Int {
        var p = p
        while parent[p] != p {
            p = parent[p]
        }
        return p
    }

    public mutating func connect(_ p: Int, _ q: Int) {
        let (a, b) = (find(p), find(q))
        guard a != b else { return }
        if size[a] < size[b] {
            parent[a] = b
            size[b] += size[a]
        } else {
            parent[b] = a
            size[a] += size[b]
        }
    }

    public func isConnected(_ p: Int, _ q: Int) -> Bool {
        find(p) == find(q)
    }
}

/// A rectangular world of particles. (0, 0) is the top-left cell, and y grows
/// downward, as on screen.
public struct Grid: Equatable, Sendable {
    public let width: Int
    public let height: Int
    private var cells: [Particle]

    public init(width: Int, height: Int) {
        precondition(width > 0 && height > 0)
        self.width = width
        self.height = height
        cells = Array(repeating: Particle(.empty), count: width * height)
    }

    // MARK: - Task 2: cells

    /// Whether (x, y) is inside the grid.
    public func contains(x: Int, y: Int) -> Bool {
        false // Replace this line.
    }

    /// The particle at (x, y). Reading outside the grid gives a barrier, so
    /// the edges act as walls; writing outside the grid does nothing.
    public subscript(x: Int, y: Int) -> Particle {
        get {
            Particle(.empty) // Replace this line.
        }
        set {
            // Your code here.
        }
    }

    // MARK: - Provided

    /// Places a new particle of the given flavor at (x, y).
    public mutating func place(_ flavor: Flavor, x: Int, y: Int) {
        self[x, y] = Particle(flavor)
    }

    /// Whether (x, y) is inside the grid and empty.
    public func isEmpty(x: Int, y: Int) -> Bool {
        contains(x: x, y: y) && self[x, y].flavor == .empty
    }

    /// Exchanges the particles at two cells.
    public mutating func swapCells(_ a: (x: Int, y: Int), _ b: (x: Int, y: Int)) {
        let particle = self[a.x, a.y]
        self[a.x, a.y] = self[b.x, b.y]
        self[b.x, b.y] = particle
    }

    /// Advances the world by one step. Rows are updated from the bottom up,
    /// and each row from left to right. A particle that moved, or was created,
    /// during this tick is not updated again until the next one.
    public mutating func tick(dice: inout some Dice) {
        var done = Set<Int>()
        for y in stride(from: height - 1, through: 0, by: -1) {
            for x in 0..<width where !done.contains(y * width + x) {
                for changed in update(x: x, y: y, dice: &dice) {
                    done.insert(changed.y * width + changed.x)
                }
            }
        }
    }

    /// Updates the particle at (x, y). Returns the cells it moved into or
    /// created new particles in, which are not updated again this tick.
    private mutating func update(x: Int, y: Int, dice: inout some Dice) -> [(x: Int, y: Int)] {
        switch self[x, y].flavor {
        case .sand: updateSand(x: x, y: y, dice: &dice)
        case .water: updateWater(x: x, y: y, dice: &dice)
        case .fountain: updateFountain(x: x, y: y)
        case .plant: updatePlant(x: x, y: y, dice: &dice)
        case .fire: updateFire(x: x, y: y, dice: &dice)
        case .empty, .barrier, .flower: []
        }
    }

    // MARK: - Task 3: sand and water

    /// Sand falls into an empty or water cell below, swapping with the water.
    /// Otherwise it slides diagonally down: pick(2) chooses which side to try
    /// first (0 is left), and it moves to the first of the two that is empty.
    private mutating func updateSand(x: Int, y: Int, dice: inout some Dice) -> [(x: Int, y: Int)] {
        [] // Replace this line.
    }

    /// Water falls into an empty cell below. Otherwise it flows sideways:
    /// pick(2) chooses which side to try first (0 is left), and it moves to the
    /// first of the two that is empty.
    private mutating func updateWater(x: Int, y: Int, dice: inout some Dice) -> [(x: Int, y: Int)] {
        [] // Replace this line.
    }

    // MARK: - Task 4: fountains and plants

    /// A fountain puts a new water particle in the cell below it, if empty.
    private mutating func updateFountain(x: Int, y: Int) -> [(x: Int, y: Int)] {
        [] // Replace this line.
    }

    /// A plant grows upward: with chance 0.05, if the cell above is empty, a
    /// new particle appears there, a flower with chance 0.1 and otherwise a
    /// plant. Ask for the first chance before checking the cell above.
    private mutating func updatePlant(x: Int, y: Int, dice: inout some Dice) -> [(x: Int, y: Int)] {
        [] // Replace this line.
    }

    // MARK: - Task 5: fire

    /// Fire spreads to each flammable neighbor above, below, left, and right,
    /// in that order, with chance 0.4 each. Then it ages by one tick, and
    /// when its lifespan reaches 0 it becomes empty.
    private mutating func updateFire(x: Int, y: Int, dice: inout some Dice) -> [(x: Int, y: Int)] {
        [] // Replace this line.
    }
}

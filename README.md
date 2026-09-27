# Swift projects

Starter code for the projects in the Swift tutorial at
[cs.dorian.page](https://cs.dorian.page/en/swift/), whose second half follows
UC Berkeley’s CS61B, *Data Structures*.

Each folder is a Swift package for one project. Read the project’s page on the
site first: it explains the tasks and the rules.

| Folder | Project |
| --- | --- |
| [`particles`](particles) | [Project 5: Particle Simulator](https://cs.dorian.page/en/swift/projects/particles/) |
| [`lldeque`](lldeque) | [Project 6: LinkedListDeque](https://cs.dorian.page/en/swift/projects/lldeque/) |
| [`arraydeque`](arraydeque) | [Project 7: ArrayDeque](https://cs.dorian.page/en/swift/projects/arraydeque/) |
| [`percolation`](percolation) | [Project 8: Percolation](https://cs.dorian.page/en/swift/projects/percolation/) |
| [`ngordnet`](ngordnet) | [Project 9: NGordNet](https://cs.dorian.page/en/swift/projects/ngordnet/) |
| [`byow`](byow) | [Project 10: Build Your Own World](https://cs.dorian.page/en/swift/projects/byow/) |

More projects are added as the tutorial reaches them.

## Getting started

Use this repository as a template (or clone it), then work in one folder at a
time:

```bash
cd lldeque
swift test
```

You need Swift 6.4 or later. The data structures and their tests are plain
Swift and run on macOS, Linux, and Windows. Projects with a user interface
also have a SwiftUI app target, which needs macOS 27 and Xcode 27: open the
folder’s `Package.swift` in Xcode, or run `swift run -c release` with the
app’s name.

Commit often. When a new project appears here, pull it into your copy with
`git pull` from this repository (add it as a remote named `upstream`).

## Credits

The projects follow the structure of CS61B’s projects (UC Berkeley). The code,
tests, and specifications here were written for Swift for this tutorial.
Solutions are not published.

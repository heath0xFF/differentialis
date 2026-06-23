import Foundation

/// Runs blocking work — git subprocesses (`Process.waitUntilExit`), file I/O, image decoding,
/// large diffs — off the main actor and delivers the result back on the caller's actor.
///
/// None of that work may run on the main thread: it freezes the UI, and worse, `waitUntilExit`
/// pumps the run loop, which re-enters SwiftUI's update cycle and crashes with EXC_BAD_ACCESS.
/// Wrap the blocking call in `await offMain { … }` and assign the result afterwards (back on the
/// main actor) — see RepositoryView / AppModel / TextComparisonView for the pattern.
func offMain<T: Sendable>(_ work: @Sendable @escaping () -> T) async -> T {
    await Task.detached(priority: .userInitiated, operation: work).value
}

/// Carries a value that isn't `Sendable` (e.g. AppKit `NSImage`) across an actor hop. Safe only
/// when the value isn't mutated concurrently — here we just hand a freshly-decoded image back.
struct Unchecked<Value>: @unchecked Sendable {
    let value: Value
    init(_ value: Value) { self.value = value }
}

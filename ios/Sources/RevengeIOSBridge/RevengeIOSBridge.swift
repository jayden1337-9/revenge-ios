import Foundation

/// Implement this adapter in the eventual iOS host using a supported JavaScript
/// engine. The host must install the globals and native modules expected by the
/// Revenge bundle before evaluating its entry bundle.
@MainActor
public protocol RevengeJavaScriptRuntime: AnyObject {
    func prepareEnvironment() async throws
    func evaluateJavaScript(_ source: String) async throws
    func invalidate() async
}

public enum RevengeHostState: Equatable {
    case idle
    case preparing
    case running
    case failed(String)
    case stopped
}

public enum RevengeHostError: Error, Equatable {
    case bundleNotFound
    case bundleIsNotUTF8
}

/// Lifecycle coordinator shared by a future iOS application target.
/// This does not provide Discord integration or a JavaScript engine by itself.
@MainActor
public final class RevengeHost {
    public private(set) var state: RevengeHostState = .idle
    private let runtime: RevengeJavaScriptRuntime

    public init(runtime: RevengeJavaScriptRuntime) {
        self.runtime = runtime
    }

    public func start(bundleURL: URL) async throws {
        guard state != .running else { return }
        state = .preparing

        do {
            guard FileManager.default.fileExists(atPath: bundleURL.path) else {
                throw RevengeHostError.bundleNotFound
            }

            let data = try Data(contentsOf: bundleURL)
            guard let source = String(data: data, encoding: .utf8) else {
                throw RevengeHostError.bundleIsNotUTF8
            }

            try await runtime.prepareEnvironment()
            try await runtime.evaluateJavaScript(source)
            state = .running
        } catch {
            state = .failed(String(describing: error))
            throw error
        }
    }

    public func stop() async {
        await runtime.invalidate()
        state = .stopped
    }
}

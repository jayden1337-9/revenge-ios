import XCTest
@testable import RevengeIOSBridge

final class RevengeIOSBridgeTests: XCTestCase {
    func testInitialStateIsIdle() async {
        await MainActor.run {
            let runtime = TestRuntime()
            let host = RevengeHost(runtime: runtime)
            XCTAssertEqual(host.state, .idle)
        }
    }

    @MainActor
    private final class TestRuntime: RevengeJavaScriptRuntime {
        func prepareEnvironment() async throws {}
        func evaluateJavaScript(_ source: String) async throws {}
        func invalidate() async {}
    }
}

import Testing
import Foundation
import Combine
import DGAsyncPublisher


@MainActor
class ViewModel {
    @Published var query = ""
    @Published var result = ""
    
    init() {
        bind()
    }
    
    private func bind() {
        $query
            .asyncMap({ await self.asyncFunction(query: $0) })
            .assign(to: &$result)
    }
    
    private func asyncFunction(query: String) async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                continuation.resume(returning: "done")
            }
        }
    }
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let viewModel = await ViewModel()
    
    await #expect(viewModel.result == "")
    
    try await Task.sleep(nanoseconds: 2_000_000_000)
    
    await #expect(viewModel.result == "done")
}

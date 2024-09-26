// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine

public extension Publisher {
    @MainActor
    func asyncMap<T: Sendable>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Failure>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let result = await transform(value)
                    promise(.success(result))
                }
            }
        }
    }
}


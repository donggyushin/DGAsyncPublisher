# DGAsyncPublisher
Let developers can use thread-safe asyncMap in Combine Publisher.


## Installation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/documentation/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DGAsyncPublisher` as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```
dependencies: [
   .package(url: "https://github.com/donggyushin/DGAsyncPublisher.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the DGAsyncPublisher target:

```
.product(name: "DGAsyncPublisher", package: "DGAsyncPublisher")
```

## Usage
```swift
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
```

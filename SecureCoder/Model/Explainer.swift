
struct Explainer: Codable, Equatable {
    let questionIndices: [Int]
    let focusLabels: [String]
    let focusComponents: [[Int]]
    let texts: [String]
}

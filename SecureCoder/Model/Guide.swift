
struct Guide: Codable, Equatable {
    let index: Int
    let fileName: String
    let explainers: [Explainer]
}

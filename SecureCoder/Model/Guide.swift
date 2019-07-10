
struct Guide: Decodable, Equatable {
    let index: Int
    let fileName: String
    let explainers: [Explainer]
}

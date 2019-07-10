
struct Explainer: Decodable, Equatable {
    struct Message: Decodable, Equatable {
        let text: String
        let languages: [ProgramingLanguage]
    }
    let questionIndices: [Int]
    let focusLabels: [String]
    let focusComponents: [[Int]]
    let messages: [Message]
//    let languages: [ProgramingLanguage]
//    let texts: [String]
}
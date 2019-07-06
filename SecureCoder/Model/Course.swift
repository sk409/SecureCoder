
struct CourseInfo: Decodable {
    let index: Int
    let title: String
    let threats: [String]
}

struct Course {
    
    //let language: ProgramingLanguage
    let index: Int
    let title: String
    let threats: [String]
    let chapters: [Chapter]
    
}

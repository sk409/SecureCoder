import Foundation


extension String {
    func toArray() -> [String]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        guard let array = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String]) as [String]??) else {
            return nil
        }
        return array
    }
}

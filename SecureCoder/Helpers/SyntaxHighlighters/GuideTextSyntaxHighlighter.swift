import UIKit

struct GuideTextSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let urlRegex = try! NSRegularExpression(pattern: "https?://[a-zA-Z./]*")
        let urlMatches = urlRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        for urlMatch in urlMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.meduimSeaGreen, range: urlMatch.range)
        }
        let fileNameRegex = try! NSRegularExpression(pattern: "[a-zA-Z0-9_-]+(.js|.html|.php|.css)")
        let fileNameMatches = fileNameRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        for fileNameMatch in fileNameMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.royalBlue, range: fileNameMatch.range)
        }
        return mutableAttributedString
    }
    
}


import UIKit

struct GuideTextSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        let urlRegex = try! NSRegularExpression(pattern: "https?://[a-zA-Z./]*")
        let urlMatches = urlRegex.matches(in: text, range: fullRange)
        for urlMatch in urlMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.meduimSeaGreen, range: urlMatch.range)
        }
        let fileNameRegex = try! NSRegularExpression(pattern: "[a-zA-Z0-9_-]+(.js|.html|.php|.css)")
        let fileNameMatches = fileNameRegex.matches(in: text, range: fullRange)
        for fileNameMatch in fileNameMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.royalBlue, range: fileNameMatch.range)
        }
        let warningRegex = try! NSRegularExpression(pattern: "これから書くコードには脆弱性があるため、実際に開発を行う場合には絶対に同じコードを書かないでください|実際にこれから書くようなコードを用いて実在するWebサイトを攻撃するようなことは絶対にしないでください")
        let warningMatches = warningRegex.matches(in: text, range: fullRange)
        for warningMatch in warningMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: warningMatch.range)
        }
        return mutableAttributedString
    }
    
}


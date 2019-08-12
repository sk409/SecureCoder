import UIKit

class Table: WebElementView {
    
    var padding: CGFloat = 16
    
    private var rowCount = 0
    private var rows = [[UILabel]]()
    private var maxWidths = [CGFloat]()
    private var maxHeights = [CGFloat]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var pointer = CGPoint.zero
        for (rowIndex, rowLabels) in rows.enumerated() {
            for (dataIndex, rowLabel) in rowLabels.enumerated() {
                addSubview(rowLabel)
                rowLabel.frame.origin = pointer
                //print(rowLabel.frame)
                pointer.x += (maxWidths[dataIndex] + padding)
            }
            pointer.x = 0
            pointer.y += (padding + maxHeights[rowIndex])
        }
    }
    
    func set(headers: [String]) {
        frame.size = .zero
        rowCount = headers.count
        maxWidths.removeAll(keepingCapacity: true)
        maxHeights.removeAll(keepingCapacity: true)
        rows.removeAll(keepingCapacity: true)
        var maxHeight: CGFloat = 0
        rows.append(headers.map { header in
            let headerLabel = UILabel()
            headerLabel.text = header
            headerLabel.textColor = .black
            headerLabel.font = .boldSystemFont(ofSize: 24)
            let labelSize = headerLabel.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            headerLabel.frame.size = labelSize
            frame.size.width += labelSize.width
            frame.size.height = max(frame.size.height, labelSize.height)
            maxWidths.append(labelSize.width)
            maxHeight = max(maxHeight, labelSize.height)
            return headerLabel
        })
        maxHeights.append(maxHeight)
        frame.size.width += (padding * CGFloat(max(headers.count - 1, 0)))
    }
    
    func append(row: [String]) {
        guard row.count == rowCount else {
            return
        }
        var rowWidth = padding * CGFloat(row.count - 1)
        var maxHeight: CGFloat = 0
        var rowLabels = [UILabel]()
        for (index, data) in row.enumerated() {
            let rowLabel = UILabel()
            rowLabels.append(rowLabel)
            rowLabel.text = data
            rowLabel.textColor = .black
            rowLabel.font = .systemFont(ofSize: 20)
            let labelSize = rowLabel.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            rowLabel.frame.size = labelSize
            maxWidths[index] = max(maxWidths[index], labelSize.width)
            rowWidth += labelSize.width
            maxHeight = max(maxHeight, labelSize.height)
        }
        rows.append(rowLabels)
        maxHeights.append(maxHeight)
        frame.size.width = max(frame.width, rowWidth)
        frame.size.height += (padding + maxHeight)
    }
    
}

import UIKit

class LabelWithActions: UILabel {
    
    // MARK: Propreties
    
    private var currentText = NSMutableAttributedString()
    private var actionForRange = [NSRange : () -> Void]()
    
    // MARK: UILabel methods
    
    override func awakeFromNib() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapRecognizer)
        
        self.isUserInteractionEnabled = true
    }
    
    // MARK: Public methods
    
    func addText(_ actionText: String) {
        addText(actionText, isAction: false)
    }
    
    func addAction(with actionText: String, action: @escaping () -> Void) {
        let length = actionText.count
        let location = self.currentText.string.count
        let range = NSRange(location: location, length: length)
        
        actionForRange[range] = action
        
        addText(actionText, isAction: true)
    }
    
    func cleanText() {
        self.text = nil
        self.attributedText = nil
        self.currentText = NSMutableAttributedString()
        self.actionForRange = [NSRange : () -> Void]()
    }
    
    // MARK: Private methods
    
    private func addText(_ actionText: String, isAction: Bool) {
        let fontSize = self.font.pointSize
        let font = isAction ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        let attributedString = NSMutableAttributedString(string: actionText, attributes: attributes)
        
        currentText.append(attributedString)
        updateText()
    }
    
    private func updateText() {
        self.attributedText = self.currentText
    }
    
    // MARK: UITapGestureRecognizer
    
    @objc
    private func textTapped(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)
        
        let textStorage = NSTextStorage(attributedString: currentText)
        
        let layoutManager = NSLayoutManager()
        
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        let symbolIndex = layoutManager.characterIndex(
            for: tapLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        for range in self.actionForRange.keys {
            let start = range.location
            let end = range.location + range.length
            
            if symbolIndex > start, symbolIndex <= end, let action = actionForRange[range] {
                action()
            }
        }
    }
    
}

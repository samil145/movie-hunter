//
//  OverviewLabel.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 17.08.24.
//

import UIKit

class OverviewLabel: UILabel {

    private var fullText: String = ""
    private var truncatedText: String = ""
    private let readMoreText = " Read More"
    private let readLessText = " Read Less"
    private let maxLines = 4
    private var isExpanded = false
    private var hasInitialSetupCompleted = false

    override var text: String? {
        didSet {
            self.fullText = text ?? ""
            self.numberOfLines = maxLines
            updateText(forState: .truncated)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment          = .left
        self.textColor              = .secondaryLabel
        font                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasInitialSetupCompleted {
            
            updateText(forState: .truncated)
            hasInitialSetupCompleted = true
        }
    }

    private enum LabelState {
        case truncated, expanded
    }

    private func updateText(forState state: LabelState) {
        switch state {
        case .truncated:
            if let truncated = getTruncatedText() {
                self.truncatedText = truncated
                self.attributedText = getAttributedText(text: truncated, readMore: true)
                self.isUserInteractionEnabled = true
            } else {
                self.attributedText = NSAttributedString(string: fullText)
                self.isUserInteractionEnabled = false
            }
            
        case .expanded:
            self.attributedText = getAttributedText(text: fullText, readMore: false)
            self.numberOfLines = 0
            
        }
        setupGestureRecognizer()
    }

    private func getTruncatedText() -> String? {
        guard let text = self.text else { return nil }

        let ellipsis = "..."
        let readMore = readMoreText
        let maxCharacters = text.count

        let truncatedText = (text as NSString).boundingRect(
            with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self.font as Any],
            context: nil
        )

        let numberOfLinesInText = Int(truncatedText.height / self.font.lineHeight)

        if numberOfLinesInText <= maxLines {
            return nil
        }

        var endIndex = text.index(text.startIndex, offsetBy: maxCharacters)
        while numberOfLinesInText > maxLines {
            endIndex = text.index(before: endIndex)
            let substring = String(text[..<endIndex]) + ellipsis + readMore

            let boundingRect = (substring as NSString).boundingRect(
                with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font as Any],
                context: nil
            )

            if Int(boundingRect.height / self.font.lineHeight) <= maxLines {
                return String(text[..<endIndex]) + ellipsis
            }
        }

        return String(text[..<endIndex]) + ellipsis
    }

    private func getAttributedText(text: String, readMore: Bool) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)

        let readMoreOrLess = readMore ? readMoreText : readLessText
        let readMoreLessRange = NSRange(location: attributedText.length, length: readMoreOrLess.count)
        attributedText.append(NSAttributedString(string: readMoreOrLess))

        attributedText.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: readMoreLessRange)
        attributedText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: readMoreLessRange)
        
        let truncatedText = (text as NSString).boundingRect(
            with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self.font as Any],
            context: nil
        )

        let numberOfLinesInText = Int(truncatedText.height / self.font.lineHeight)

        if numberOfLinesInText <= 4 && !readMore
        {
            return NSMutableAttributedString(string: text)
        }
        
        return attributedText
    }

    private func setupGestureRecognizer() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleReadMoreOrLessTap))
        self.addGestureRecognizer(tap)
    }

    @objc private func handleReadMoreOrLessTap() {
//        if getTruncatedText() != nil
//        {
            isExpanded.toggle()
            if isExpanded {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.updateText(forState: .expanded)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.updateText(forState: .truncated)
                }
            }
        
    }
}

    //
    //  RegexKeywords.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 03/04/2025.
    //

import AppKit.NSColor

struct RegexKeywords {
    static let keywords = ["print", "func", "var", "let", "struct", "if", "else", "guard", "static", "do", "catch", "try", "return"]
}

extension String {
    
        /// Applies highlight to String based on keywords
        /// - Parameter nonAttributedText: String to be highlighted
        /// - Returns: Attributed String with keywords highlighted
    func highlightRegex(using keywords: [String]) -> NSAttributedString {
        let text = NSMutableAttributedString(string: self)
        let pattern = "\\b" + keywords.joined(separator: "|") + "\\b"
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return text
        }
        
        text
            .addAttribute(
                .foregroundColor,
                value: NSColor.textColor,
                range: NSRange(0..<text.length)
            )
        
        let matches = regex.matches(in: text.string, range: NSRange(0..<text.length))
        
        for match in matches {
            text
                .addAttribute(
                    .foregroundColor,
                    value: NSColor.controlAccentColor,
                    range: match.range
                )
        }
        
        return text
    }
}

extension AttributedString {
    func withErrorLink() -> AttributedString {
        var attributed = self
        
        let pattern = #"(\w+.swift):(\d+):(\d+):\s+error:"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return attributed
        }
        
        let plainText = String(self.characters)
        let nsString = plainText as NSString
        let matches = regex.matches(in: plainText, range: NSRange(location: 0, length: nsString.length))
        
        for match in matches {
            if let fileRange = Range(match.range, in: plainText),
               let lineNumberRange = Range(match.range(at: 2), in: plainText) {
                
                    // Convert the full match range to an AttributedString range
                if let attrRangeStart = AttributedString.Index(fileRange.lowerBound, within: attributed),
                   let attrRangeEnd = AttributedString.Index(fileRange.upperBound, within: attributed) {
                    
                    let completeRange = attrRangeStart..<attrRangeEnd
                    let lineNumberString = String(plainText[lineNumberRange])
                    
                    if let url = URL(string: "neuma://line/\(lineNumberString)") {
                        attributed[completeRange].link = url
                    }
                }
            }
        }
        return attributed
    }
}

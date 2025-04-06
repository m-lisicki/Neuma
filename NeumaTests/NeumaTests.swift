    //
    //  NeumaTests.swift
    //  NeumaTests
    //
    //  Created by Michał Lisicki on 30/03/2025.
    //

import Testing
import AppKit.NSColor
@testable import Neuma

struct NeumaTests {

    @Test("Highlighter Test", arguments: [
        "func test() { print(\"Hello, World!\") }",
        "func greet() { print(\"Hi there!\") }",
        "let x = 42; func compute() { print(x) }",
        "if true { func check() { print(\"Inside if\") } }",
        "func duplicate() { print(\"first\"); print(\"second\") }"
    ])
    func testHighlightRegex(sampleText: String) async throws {
        let attributedText = sampleText.highlightRegex(using: RegexKeywords.keywords)

        var foundFuncHighlight = false, foundPrintHighlight = false

        attributedText.enumerateAttribute(.foregroundColor, in: NSRange(location: 0, length: attributedText.length)) { (value, range, _) in
            if let color = value as? NSColor, color == NSColor.systemPink {
                let word = (attributedText.string as NSString).substring(with: range)
                if word == "func" {
                    foundFuncHighlight = true
                }
                if word == "print" {
                    foundPrintHighlight = true
                }
            }
        }

        #expect(foundFuncHighlight == true && foundPrintHighlight == true)
    }
}

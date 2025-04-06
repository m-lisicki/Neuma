    //
    //  ApplicationDelegate.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 03/04/2025.
    //

import AppKit
import SwiftUI

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            NotificationCenter.default.post(name: Notification.Name("jumpToLine"), object: url.lastPathComponent)
        }
    }
}

struct TextEditorWrapper: NSViewRepresentable {
    @Binding var nonAttributedString: String
    
    func makeCoordinator() -> TextEditorDelegate {
        TextEditorDelegate(nonAttributedString: $nonAttributedString)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let textEditor = AttributedTextEditor()
        textEditor.textView.delegate = context.coordinator
        
        NotificationCenter.default.addObserver(forName: Notification.Name("jumpToLine"), object: nil, queue: .main) { notification in
            let lineString = notification.object as? String
            let lineNumber = lineString.flatMap { Int($0) }
            
            Task { @MainActor in
                guard let newLineInt = lineNumber, newLineInt > 0 else { return }
                
                let lines = textEditor.textView.string.components(separatedBy: "\n")
                guard newLineInt <= lines.count else { return }
                
                var location = 0
                for i in 0..<(newLineInt - 1) {
                    location += lines[i].count + 1
                }
                
                let nsText = textEditor.textView.string as NSString
                let lineRange = nsText.lineRange(for: NSRange(location: location, length: 0))
                
                textEditor.textView.scrollRangeToVisible(lineRange)
                textEditor.textView.setSelectedRange(NSRange(location: location, length: 0))
                textEditor.textView.window?.makeFirstResponder(textEditor.textView)
            }
        }
        
        return textEditor.scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            if textView.string != nonAttributedString {
                let selectedRange = textView.selectedRange()
                
                textView.textStorage?.setAttributedString(nonAttributedString.highlightRegex(using: RegexKeywords.keywords))
                
                textView.setSelectedRange(selectedRange)
            }
        }
    }
}

class TextEditorDelegate: NSObject, NSTextViewDelegate {
    @Binding var nonAttributedString: String
    
    init(nonAttributedString: Binding<String>) {
        _nonAttributedString = nonAttributedString
    }
    
    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        let newText = textView.string
        
        let selectedRange = textView.selectedRange()
        
        textView.textStorage?.setAttributedString(newText.highlightRegex(using: RegexKeywords.keywords))
        
        textView.setSelectedRange(selectedRange)
        
        nonAttributedString = newText
    }
}



class AttributedTextEditor: NSView {
    let textView: NSTextView
    let scrollView: NSScrollView
    
    override init(frame frameRect: NSRect) {
        
        textView = NSTextView(usingTextLayoutManager: true)
        textView.isEditable = true
        textView.isRichText = false
        textView.font = NSFont.monospacedSystemFont(ofSize: 0.0, weight: .regular)
        textView.autoresizingMask = [.width, .height]
        textView.isGrammarCheckingEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isContinuousSpellCheckingEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticDataDetectionEnabled = false
        
        scrollView = NSTextView.scrollableTextView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = textView
        
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

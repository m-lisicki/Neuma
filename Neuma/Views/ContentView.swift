    //
    //  ContentView.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 29/03/2025.
    //

import SwiftUI

struct ContentView: View {
    @Binding var document: WritingAppDocument
    
    @State private var isRunning: Bool = false
    
    @State var documentContent = DocumentContent()
    @State var lineNumber: Int?
    let fileURL: URL?
    
    var body: some View {
        VStack {
            HSplitView {
                TextEditorWrapper(nonAttributedString: $document.text)
                    .frame(minWidth: 300, maxWidth: .infinity)
                if documentContent.outputText == "" {
                    OutputView(content: $documentContent)
                        .fixedSize(horizontal: true, vertical: false)
                } else {
                    OutputView(content: $documentContent)
                        .frame(minWidth: 200, maxWidth: .infinity)
                }
            }
        }
        .toolbar {
            if isRunning {
                Image(systemName: "slowmo")
                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, options: .repeat(.continuous))
            } else if let code = documentContent.exitCode {
                if code != 0 {
                    Text("Exit Code: \(code)")
                        .foregroundStyle(Color.accentColor)
                }
            }
            Button(action: runScript) {
                Image(systemName: isRunning ? "square.circle" : "play.square")
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
            }
            .disabled(fileURL == nil)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .toolbarBackground(.ultraThinMaterial)
    }
    
    func runScript() {
        documentContent.outputText = ""
        isRunning = true
        documentContent.exitCode = nil
        
        if ScriptRunner.terminateIfActive() {
            isRunning = false
            return
        }
        
        guard let scriptURL = fileURL else {
            documentContent.outputText += "Error writing script: file path not found"
            isRunning = false
            return
        }
        
        ScriptRunner.run(scriptPath: scriptURL.path) { result in
            Task { @MainActor in
                switch result {
                    case .output(let text):
                        self.documentContent.outputText += text
                    case .finished(let code):
                        self.documentContent.exitCode = code
                        self.isRunning = false
                        if self.documentContent.exitCode != 0 {
                            self.documentContent.outputText = self.documentContent.outputText.withErrorLink()
                        }
                    case .executionError(let executionErrorInfo):
                        self.documentContent.outputText += executionErrorInfo
                }
            }
        }
    }
}


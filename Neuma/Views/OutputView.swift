    //
    //  OutputView.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 03/04/2025.
    //

import SwiftUI

struct OutputView: View {
    @Binding var content: DocumentContent
    
    var body: some View {
        ScrollView {
            Text(content.outputText)
                .monospaced()
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.overlay(alignment: .topTrailing) {
            if content.outputText != "" {
                Button(action: {
                    content.outputText = ""
                    content.exitCode = nil
                }) {
                    Image(systemName: "clear")
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.secondarySystemFill))
    }
}

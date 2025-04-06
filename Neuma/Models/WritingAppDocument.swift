    //
    //  WritingAppDocument.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 28/03/2025.
    //

import SwiftUI
import UniformTypeIdentifiers

struct DocumentContent {
    var outputText: AttributedString = ""
    var exitCode: Int32?
}

struct WritingAppDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.swiftSource] }
    
    var text: String
    
    init(text: String = "") {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return .init(regularFileWithContents: data)
    }
}

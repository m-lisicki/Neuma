    //
    //  ScriptyApp.swift
    //  Scripty
    //
    //  Created by Michał Lisicki on 28/03/2025.
    //

import SwiftUI

@main
struct ScriptyApp: App {
    @NSApplicationDelegateAdaptor(ApplicationDelegate.self) var appDelegate

    var body: some Scene {
        DocumentGroup(newDocument: WritingAppDocument()) { file in
            ContentView(document: file.$document, fileURL: file.fileURL)
        }

    }
}

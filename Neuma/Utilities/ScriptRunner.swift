    //
    //  ScriptRunner.swift
    //  Neuma
    //
    //  Created by Michał Lisicki on 28/03/2025.
    //

import Foundation

@MainActor
class ScriptRunner {
    private static var currentProcess: Process?
    
    enum RunnerResult {
        case output(AttributedString)
        case finished(exitCode: Int32)
        case executionError(AttributedString)
    }
    
        /// Terminates any active process if present
        /// - Returns: Whether the process was terminated
    static func terminateIfActive() -> Bool {
        if let process = currentProcess, process.isRunning {
            process.terminate()
            return true
        }
        return false
    }
    
        /// Runs the Swift script at provided path
        /// - Parameters:
        ///   - scriptPath: The file path of the Swift script
        ///   - callback: Called with each output updates during execution including errors and exitCodes
    static func run(scriptPath: String, callback: @escaping @Sendable (RunnerResult) -> Void) {
        
        let process = Process()
        currentProcess = process
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", scriptPath]
        
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        
        func readPipe(pipe: Pipe) {
            pipe.fileHandleForReading.readabilityHandler = { handle in
                let data = handle.availableData
                if !data.isEmpty, let output = String(data: data, encoding: .utf8) {
                    callback(.output(AttributedString(output)))
                }
            }
        }
        
        readPipe(pipe: stdoutPipe)
        readPipe(pipe: stderrPipe)
        
        do {
            try process.run()
        } catch {
            callback(.executionError(AttributedString("Failed to execute process: \(error.localizedDescription)\n")))
            return
        }
        
        process.terminationHandler = { proc in
            stdoutPipe.fileHandleForReading.readabilityHandler = nil
            stderrPipe.fileHandleForReading.readabilityHandler = nil
            
            Task { @MainActor in
                currentProcess = nil
            }
            
            callback(.finished(exitCode: proc.terminationStatus))
        }
        
    }
}

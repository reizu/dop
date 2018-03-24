import Foundation
import Basic
import Utility

// TODO: Rename to ShellClient, ShellDriver or ShellUtils?
// TODO: Extract to other package.
// TODO: support streaming output.

extension String {
    func escapingForShell() -> String {
        return self
            .replacingOccurrences(of: "&", with: "\\&")
            .replacingOccurrences(of: "!", with: "\\!")
    }
}

public class Shell {
    let isVerbose: Bool

    public init(verbose: Bool = true) {
        self.isVerbose = verbose
    }

    func log(_ text: String) {
        if isVerbose {
            print(text)
        }
    }

    @discardableResult
    public func execute(_ command: String) throws -> ProcessResult {
        log(command)

        let process = Process(arguments: ["sh", "-c", command])
        try process.launch()

        let result = try process.waitUntilExit()

        if let output = try? result.utf8Output() {
            print(output, terminator: "")
        }

        switch result.exitStatus {
        case .terminated(let status):
            if status != 0 {
                if let output = try? result.utf8stderrOutput() {
                    print(output, terminator: "")
                }
                break
            }

        default:
            break
        }

        return result
    }

    public func execute(script: String) throws {
        for scriptCommand in script.split(separator: "\n") {
            try execute(String(scriptCommand))
        }
    }

    public func ensureDirectoryExists(atPath path: String) throws {
        let fm = FileManager.default

        if !fm.fileExists(atPath: path) {
            print("Created \(path)")
            try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // TODO: allow override/not-override
    public func writeTextFile(atPath path: String, contents: String) throws {
        try contents.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
        print("Created \(path)")
    }
    
    public func removeFile(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
        print("Removed \(path)")
    }

    public func removeDirectory(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
        print("Removed \(path)")
    }
}
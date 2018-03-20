import Foundation
import Basic
import Utility
import DopTool

// https://www.hackingwithswift.com/articles/44/apple-s-new-utility-library-will-power-up-command-line-apps

guard let projectDescriptor = loadProjectDescriptor() else {
    print("Cannot load `dop.json`")
    exit(1)
}

do {
    let parser = ArgumentParser(usage: "subcommand <options>", overview: "Support devops workflows")

//    let initParser = parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")
//    let numbers = initParser.add(positional: "numbers", kind: [Int].self, usage: "List of numbers to operate with.")
    
    parser.add(subparser: "build-release", overview: "Build the release executable")
    parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")
    parser.add(subparser: "clean", overview: "Remove all files generated by dop")

    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))

    guard let subcommand = result.subparser(parser) else {
        parser.printUsage(on: stdoutStream)
        exit(0)
    }

    switch (subcommand) {
    case "build-release":
        BuildReleaseJob(projectDescriptor: projectDescriptor).run()
        
    case "init":
        // result.get(numbers)!
        InitJob(projectDescriptor: projectDescriptor).run()

    case "clean":
        CleanJob().run()

    default:
        print("Unrecognized command '\(subcommand)'")
    }
} catch let error as ArgumentParserError {
    print(error.description)
} catch {
    print(error.localizedDescription)
}

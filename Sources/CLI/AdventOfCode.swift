// The Swift Programming Language
// https://docs.swift.org/swift-book

import PklSwift
import Foundation

struct AdventOfCodeConfig: Decodable, Sendable {
    let year: Int
    let code_folder: String
    let data_folder: String
}

@main struct AdventOfCode {
    static let fileService = FileService()

    nonisolated static func getConfigValues() async throws -> AdventOfCodeConfig  {
        try await withEvaluator { evaluator in
            try await evaluator.evaluateModule(source: .path("config.pkl"), as: AdventOfCodeConfig.self)
        }
    }

    // static func downloadInput(config: AdventOfCodeConfig, day:Int) async throws -> String {
    //     let inputString = "https://adventofcode.com/\(config.year)/day/\(day)/input"
    //     guard let inputURL = URL(string: inputString) else {
    //         throw AdventOfCodeError.runtimeError("couldn't make url")
    //     }
    //     let data = try Data(contentsOf: inputURL)
    //     //let outputString = FileIO.makeFileURL(string: )
    //     //data.write(to: URL)

    // }

    static func main() async throws {
        print("hello world")
        let result = try await getConfigValues()
        print(result.year)
        print(result.code_folder)
        print(result.data_folder)

        print(await fileService.cleanBashFileInput(result.code_folder))
        print(await fileService.cleanBashFileInput(result.data_folder))
        /// the very first element is the current script
let script = CommandLine.arguments[0]
print("Script:", script)

/// you can get the input arguments by dropping the first element
let inputArgs = CommandLine.arguments.dropFirst()
print("Number of arguments:", inputArgs.count)

print("Arguments:")
for arg in inputArgs {
    print("-", arg)
}

/// reading lines from the standard input
print("Please enter your input:")
guard let input = readLine(strippingNewline: true) else {
    fatalError("Missing input")
}
    }
}
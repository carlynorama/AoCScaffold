// The Swift Programming Language
// https://docs.swift.org/swift-book

import PklSwift
import Foundation
import FileWrangler

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
        let script = CommandLine.arguments[0]
        print("Script Being Run:", script)

        let result = try await getConfigValues()
        print(result.year)
        print(result.code_folder)
        print(result.data_folder)

        print(await fileService.cleanBashFileInput(result.code_folder))
        print(await fileService.cleanBashFileInput(result.data_folder))
        /// the very first element is the current script


        /// you can get the input arguments by dropping the first element
        let inputArgs = Array(CommandLine.arguments.dropFirst())
        print("Number of arguments:", inputArgs.count)

        print(inputArgs)
        print("Arguments:")
        for arg in inputArgs {
            print("-", arg)
        }

        if inputArgs.count == 2 {
             let arg = inputArgs[0]
             let day = Int(inputArgs[1])!
            switch arg {
                case "make": 
                    try await makeDay(day, config:result)
                case "data": 
                    try await makeDataWrap(day, config:result)
            default:    
            print("did not recognize input")

             }
        }
    }
}


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
    static let httpService = HTTPRequestService(asUserAgent: "Simple Swift AoC Tool by carlynorama.com as part of github.com/carlynorama/AoCScaffold")

    nonisolated static func getConfigValues() async throws -> AdventOfCodeConfig  {
        try await withEvaluator { evaluator in
            try await evaluator.evaluateModule(source: .path("config.pkl"), as: AdventOfCodeConfig.self)
        }
    }

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
                case "fetch": 
                    try await fetchData(day, config: result)
            default:    
            print("did not recognize input")

             }
        }
    }

    static nonisolated func dayBaseRemote(_ day:Int, config: AdventOfCodeConfig) async throws -> URL {
        let fetchLocation = "https://adventofcode.com/\(config.year)/day/\(day)"
        guard let remoteURL = URL(string: fetchLocation) else {
            throw AdventOfCodeError.runtimeError("couldn't make url from: \(fetchLocation)")
        }
        return remoteURL
    }

    static nonisolated func dayBasePrivateLocal(_ day:Int, config: AdventOfCodeConfig) async throws -> URL {
        let baseDataFolder = URL(fileURLWithPath: await fileService.cleanBashFileInput(config.data_folder))
        return baseDataFolder.appending(component: (String(format:"%02d", day))) 
    }
}


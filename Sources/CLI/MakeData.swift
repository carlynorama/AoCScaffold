import Foundation
import FileWrangler

extension AdventOfCode {
    nonisolated static func makeDataWrap(_ dayNum:Int, config:AdventOfCodeConfig) async throws {
        let baseDataFolder = URL(fileURLWithPath: await fileService.cleanBashFileInput(config.data_folder))
        let dataForDay = baseDataFolder.appending(component: (String(format:"%02d", dayNum)))
        let rawDataFile = dataForDay.appending(component:"data.txt")



        let wrappedFileName = "realData.swift"
        if await fileService.fileExists(rawDataFile) {

            let prefix = #"""
            let realData = """

            """#

            let suffix = #"""

            """
            """#

            let wrappedFile = rawDataFile.deletingLastPathComponent().appending(component:wrappedFileName)
            try await fileService.touch(wrappedFile)
            let fileHandle = try FileHandle(forWritingTo: wrappedFile)
            fileHandle.write(prefix.data(using: .utf8)!)
            fileHandle.write(try Data(contentsOf: rawDataFile))
            fileHandle.write(suffix.data(using: .utf8)!)
        }


        
    }


    
}

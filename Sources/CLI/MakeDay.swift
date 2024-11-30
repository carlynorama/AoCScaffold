import Foundation

extension AdventOfCode {
    nonisolated static func makeDay(_ dayNum:Int, config:AdventOfCodeConfig) async throws {
        //TODO: Fix !

        let baseDataFolder = URL(string: await fileService.cleanBashFileInput(config.data_folder))!
        let dataForDay = baseDataFolder.appending(component: (String(format:"%02d", dayNum))) 
        var result = try await fileService.touch(dataForDay.appending(component: "data.txt"))
        print(result)
        result = try await fileService.touch(dataForDay.appending(component: "story.txt"))
        print(result)
        result = try await fileService.touch(dataForDay.appending(component: "scratch_notes.md"))
        print(result)
        let baseCodeFolder = URL(string: await fileService.cleanBashFileInput(config.code_folder))!
        let codeForDay = baseCodeFolder.appending(component: (String(format:"%02d", dayNum)))
        try await fileService.createDirectory(string: codeForDay.absoluteString, withSubs: true)
        try baseDayFileContent.write(to: codeForDay.appending(component: "main.swift"), atomically: true, encoding: .utf8)
        
    }

    static var baseDayFileContent:String {
        """
        print("Hello Brand New Day")
        """
    }
}
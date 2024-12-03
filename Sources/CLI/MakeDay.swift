import Foundation
import FileWrangler

extension AdventOfCode {
    nonisolated static func makeDay(_ dayNum:Int, config:AdventOfCodeConfig) async throws {
        //TODO: Fix !

        let baseDataFolder = URL(string: await fileService.cleanBashFileInput(config.data_folder))!
        let dataForDay = baseDataFolder.appending(component: (String(format:"%02d", dayNum))) 
        var result = try await fileService.touch(dataForDay.appending(component: "data.txt"))
        print(result)
        result = try await fileService.touch(dataForDay.appending(component: "story.md"))
        print(result)
        result = try await fileService.touch(dataForDay.appending(component: "scratch_notes.md"))
        print(result)
        try baseAnswersContent.write(to: dataForDay.appending(component: "answers.pkl"), atomically: true, encoding: .utf8)

        let baseCodeFolder = URL(string: await fileService.cleanBashFileInput(config.code_folder))!
        let codeForDay = baseCodeFolder.appending(component: (String(format:"%02d", dayNum)))
        try await fileService.createDirectory(string: codeForDay.absoluteString, withSubs: true)
        try blankMain(for:dayNum).write(to: codeForDay.appending(component: "main.swift"), atomically: true, encoding: .utf8)
        try baseContentForTestData.write(to: codeForDay.appending(component: "testData.swift"), atomically: true, encoding: .utf8)
        
    }

    static var baseDayFileContent:String {
        """
        print("Hello Brand New Day")
        """
    }

    static var baseAnswersContent:String {
        """
        p1t:String = 
        p2t:String = 
        p1r:String = 
        p2r:String = 
        """
    }

    static var baseContentForTestData:String {
        #"""
        let test1 = """
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """
        """#
    }

    static func blankMain(for day:Int) -> String {
        """
        print("Hello Brand New Day \(day)")


        let firstStructure = makeData(input:test1)

        func makeData(input:String) -> ([[Int]]) {
            input.split(separator: "\\n")
                .map { line in
                    line.split(separator: " ") 
                        .map { Int($0)! }
                    }
        }


        //MARK: --- Part: 1

        let p1 = \(day)
        // -----------------------------------------------------------------------------
        print("Part 1:" , p1)
        // -----------------------------------------------------------------------------

        // --- Part: 2
        
        let p2 = \(day * 2)
        // -----------------------------------------------------------------------------
        print("Part 2:" , p2)
        // -----------------------------------------------------------------------------
        """
        
    }
}
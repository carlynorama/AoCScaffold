import Foundation
import FileWrangler


//Thanks to https://github.com/BruceMcRooster/aoc-2024/blob/main/GetDay for the cookie session 
//and his reference https://github.com/scarvalhojr/aoc-cli/blob/ebb1069b2946320c76ed676cf26f0a287d4f64fd/README.md?plain=1#L17
extension AdventOfCode {

    static nonisolated func sessionData() async throws -> (key:String, expires:Date) {
        try DotEnv.loadDotEnv()
        //in a .env file
        //ADVENT_OF_CODE_SESSION=Y0UrC00k13Inf0
        guard let sessionKey = DotEnv.getEnvironmentVar("ADVENT_OF_CODE_SESSION") else {
            throw AdventOfCodeError.runtimeError("No Cookie Data in .env")
        }
        guard let sessionExpires = DotEnv.getEnvironmentVar("ADVENT_OF_CODE_SESSION_EXPR") else {
            throw AdventOfCodeError.runtimeError("No Cookie expiration date in .env")
        }
        let basicFormatStyle = Date.FormatStyle()
        let date = try basicFormatStyle.parse(sessionExpires)
        return (sessionKey, date)
    }
    static nonisolated func createCookie() async throws ->  HTTPCookie {
        let sessionData =  try await sessionData()
        let cookieProperties: [HTTPCookiePropertyKey: Any] = [
            .domain: ".adventofcode.com",
            .path: "/",
            .name: "session",
            .value: sessionData.key,
            .secure: true,
            .expires: sessionData.expires
        ]

        guard let cookie = HTTPCookie(properties: cookieProperties) else {
            throw AdventOfCodeError.runtimeError("Couldn't not make cookie from data.")
        }
        return cookie
    }

    static nonisolated func fetchData(_ day:Int, config: AdventOfCodeConfig) async throws {

        let baseRemoteURL = try await dayBaseRemote(day, config: config)
        let dataURL = baseRemoteURL.appending(component: "input")

        // var inputRequest = URLRequest(url: dataURL)
        let retrieved_cookie = httpService.readCookie(forURL: dataURL)
        if retrieved_cookie.isEmpty {
            //TODO: zot the cookies and run it again. 
            //when this worked the cookie policy was set to never. i.e. 1, always is 0
            //print(httpService.cookiePolicy().rawValue)
            let cookie = try await createCookie()
            print(cookie)
            httpService.setCookie(cookie)
        }
        
        //let pageData = try Data(contentsOf: dataURL)
        let pageData = try await httpService.fetchData(from: dataURL)

        let baseLocal = try await dayBasePrivateLocal(day, config: config)
        let dataFileURL = baseLocal.appending(component: "data.txt")
        //var result = try await fileService.touch(dataFileURL)
        
        try pageData.write(to: dataFileURL)
    }

    static nonisolated func fetchStory(_ day:Int, config: AdventOfCodeConfig) async throws {

        let baseRemoteURL = try await dayBaseRemote(day, config: config)
        let storyURL = baseRemoteURL

        // var inputRequest = URLRequest(url: dataURL)
        let retrieved_cookie = httpService.readCookie(forURL: storyURL)
        if retrieved_cookie.isEmpty {
            //TODO: zot the cookies and run it again. 
            //when this worked the cookie policy was set to never. i.e. 1, always is 0
            //print(httpService.cookiePolicy().rawValue)
            let cookie = try await createCookie()
            print(cookie)
            httpService.setCookie(cookie)
        }
        
        //let pageData = try Data(contentsOf: dataURL)
        let pageData = try await httpService.fetchData(from: storyURL)

        let baseLocal = try await dayBasePrivateLocal(day, config: config)
        let dataFileURL = baseLocal.appending(component: "data.txt")
        //var result = try await fileService.touch(dataFileURL)
        
        try pageData.write(to: dataFileURL)
    }


}

import Foundation

//From APIng 
//https://github.com/carlynorama/APIng/blob/2a4e3620eaff902254d33e103b08ea832e6bc134/Sources/APIng/DotEnv.swift
public enum DotEnv {
    
    //should prefer ProcessInfo.processInfo.environment["KEY"]
    public static func getEnvironmentVar(_ key: String) -> String? {
        guard let rawValue = getenv(key) else { return nil }
        return String(utf8String: rawValue)
    }
    public static func setEnvironment(key:String, value:String, overwrite: Bool = false) {
        setenv(key, value, overwrite ? 1 : 0)
    }
    
    public static func loadDotEnv() throws {
        if let envString = try? String(contentsOf: URL(fileURLWithPath: ".env")) {
            loadIntoEnv(envString)
        } else {
            fatalError("can't find .env file.")
        }
    }
    
    public static func loadSecretsFile(url:URL) throws {
        //let url = URL(fileURLWithPath: ".env")
        guard let envString = try? String(contentsOf: url) else {
           fatalError("no env file data")
        }
        loadIntoEnv(envString)
    }
    
    private static func loadIntoEnv(_ envString:String) {
        envString
            .trimmingCharacters(in: .newlines)
            .split(separator: "\n")
            .lazy //may or may not save anything
            .filter({$0.prefix(1) != "#"})  //is comment
            .map({ $0.split(separator: "=").map({String($0.trimmingCharacters(in: CharacterSet(charactersIn:"\"\'")))}) })
            .forEach({  addToEnv(result: $0) })

        func addToEnv(result:Array<String>) {
            if result.count == 2  {
                //print(result[0], result[1])
                setEnvironment(key: result[0], value: result[1], overwrite: true)
            } else {
                //item would of had to have contained more than 1 "=" or none at all. I'd like to know about that for now.
                print("Failed dotenv add: \(result)")
            }
        }
    }
    

}

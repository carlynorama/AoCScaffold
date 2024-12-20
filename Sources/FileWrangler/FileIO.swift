//
//  File.swift
//
//
//  Created by Carlyn Maw on 2/24/24.
//

import Foundation

public actor FileService {
    let fileManager = FileManager.default

    public init() {}


    // public func fileExists(_ string: String) -> Bool {
    //     fileManager.fileExists(atPath: string)
    //     let x = fileManager.attributeKeys
    //     //fileManager.attributesOfItem(atPath: String)
    // }

    public func fileExists(_ url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }

    @discardableResult
    public func touch(_ url: URL) throws -> Bool {
        let result = fileManager.createFile(atPath: url.path, contents: nil)
        if !result {
            let dir = url.deletingLastPathComponent()
            try fileManager.createDirectory(
            atPath: dir.path(),
            withIntermediateDirectories: true)
            let tryAgain = fileManager.createFile(atPath: url.path, contents: nil)
            return tryAgain
        } else {
            return result
        }
    }

    public func createDirectory(string: String, withSubs: Bool) throws {
        try fileManager.createDirectory(
            atPath: string,
            withIntermediateDirectories: withSubs)  //,
        //attributes: [FileAttributeKey : Any]?
    }

    public func deleteFile(at url: URL) throws {
        if fileManager.isDeletableFile(atPath: url.path()) {
            try fileManager.removeItem(at: url)
        }
    }

    //Old School.
    func timeStamp(forDate date: Date = Date(), withFormat: String = "YYYYMMdd'T'HHmmss")
        -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = withFormat
        return formatter.string(from: date)
    }

    func timeStamp() -> String {
        return Date.now.ISO8601Format(
            .iso8601(timeZone: .current, dateSeparator: .omitted, timeSeparator: .omitted))
    }

    //--------------------------------------------------------------- URL Creation

    func verifyFileURL(string: String) throws -> URL {
        if fileManager.fileExists(atPath: string) {
            return URL(filePath: string)
        } else {
            throw FileIOError.noFileAtURL(string)
        }
    }

   func makeFileURL(string: String) throws -> URL {
        if fileManager.fileExists(atPath: string) {
            return URL(filePath: string)
        } else {
            let url = URL(filePath: string)
            try touch(url)
            return url
        }
    }

    
    //MacOS only?
    func currentUserString() -> String {
        ProcessInfo.processInfo.environment["USER"]!
        //C-Code version, not the shell env info, exactly
        // let id = getuid()
        // let p = getpwuid(id)!
        // return (String(cString: p.pointee.pw_name))
    }

    //look for $USER 
    //TODO: $HOME, ~
    public func cleanBashFileInput(_ input: some StringProtocol) -> String {
        input.replacingOccurrences(of: "$USER", with: currentUserString())
    }

    //    static func makeURL(
    //        toFileNamed documentName: String,
    //        inFolder folderName: String,
    //        withTimeStamp: Bool,
    //        withExtension ext: String,
    //        relativeTo: String
    //    ) {
    //        let timeStamp = withTimeStamp ? "" : "_\(timeStamp())"
    //        //TODO: will this be a file schema URL???
    //        if var baseURL = URL(string: relativeTo) {
    //            baseURL.append(components: folderName, "\(documentName)\(timeStamp)")
    //            baseURL.appendPathExtension(ext)
    //        }
    //    }

    //------------------------------------------------- Read, Write, Append

    func write<T: Encodable>(
        _ value: T,
        to url: URL,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws {
        let data = try encoder.encode(value)
        try data.write(to: url)
    }

    func append(_ data: Data, to url: URL) throws {
        let fileHandle = try FileHandle(forWritingTo: url)
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
        fileHandle.closeFile()
    }

    //With functions in  Data+JSON there is a lot more flexibility.
    func read<T: Decodable>(
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let data = try Data(contentsOf: url)
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }

    //------------------------------------------------- Attributes

    func lastModified(of url: URL) throws -> Date {
        //works in linux?
        //if let date = try storageUrl.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate

        let attribute = try fileManager.attributesOfItem(atPath: url.path)
        if let date = attribute[FileAttributeKey.modificationDate] as? Date {
            return date
        } else {
            throw FileIOError.fileAttributeUnavailable("modificationDate")
        }
    }

    //The corresponding value is an NSNumber object containing an unsigned long long.
    //Important
    //If the file has a resource fork, the returned value does not include the size of the resource fork.
    func size(of url: URL) throws -> Int {
        let attribute = try fileManager.attributesOfItem(atPath: url.path)
        if let size = attribute[FileAttributeKey.size] as? Int {
            return size
        } else {
            throw FileIOError.fileAttributeUnavailable("size")
        }
    }

}

//Feb 2024 Copy/Paste from NSData descriptions.
//WritingOptions
// static var atomic: NSData.WritingOptions
// An option to write data to an auxiliary file first and then replace the original file with the auxiliary file when the write completes.
// static var withoutOverwriting: NSData.WritingOptions
// An option that attempts to write data to a file and fails with an error if the destination file already exists.
// static var noFileProtection: NSData.WritingOptions
// An option to not encrypt the file when writing it out.
// static var completeFileProtection: NSData.WritingOptions
// An option to make the file accessible only while the device is unlocked.
// static var completeFileProtectionUnlessOpen: NSData.WritingOptions
// An option to allow the file to be accessible while the device is unlocked or the file is already open.
// static var completeFileProtectionUntilFirstUserAuthentication: NSData.WritingOptions
// An option to allow the file to be accessible after a user first unlocks the device.
// static var fileProtectionMask: NSData.WritingOptions
// An option the system uses when determining the file protection options that the system assigns to the data.

//Reading Options
// static var mappedIfSafe: NSData.ReadingOptions
// A hint indicating the file should be mapped into virtual memory, if possible and safe.
// static var uncached: NSData.ReadingOptions
// A hint indicating the file should not be stored in the file-system caches.
// static var alwaysMapped: NSData.ReadingOptions
// Hint to map the file in if possible.

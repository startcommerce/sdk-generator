import XCTest
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Appwrite
import AsyncHTTPClient
import NIO

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        print("Test Started")
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() async throws {
        let client = Client()
            .setEndpointRealtime("ws://demo.appwrite.io/v1")
            .setProject("console")
            .addHeader(key: "Origin", value: "http://localhost")
            .setSelfSigned()

        let foo = Foo(client)
        let bar = Bar(client)
        let general = General(client)
        let realtime = Realtime(client)
        var realtimeResponse = "Realtime failed!"

        let expectation = XCTestExpectation(description: "realtime server")    
        
        realtime.subscribe(channels: ["tests"]) { message in
            realtimeResponse = message.payload!["response"] as! String
            expectation.fulfill()
        }
        
        var mock: Mock

        // Foo Tests
        mock = try await foo.get(x: "string", y: 123, z: ["string in array"])
        print(mock.result)

        mock = try await foo.post(x: "string", y: 123, z: ["string in array"])
        print(mock.result)

        mock = try await foo.put(x: "string", y: 123, z: ["string in array"])
        print(mock.result)

        mock = try await foo.patch(x: "string", y: 123, z: ["string in array"])
        print(mock.result)

        mock = try await foo.delete(x: "string", y: 123, z: ["string in array"])
        print(mock.result)


        // Bar Tests
        mock = try await bar.get(xrequired: "string", xdefault: 123, z: ["string in array"])
        print(mock.result)

        mock = try await bar.post(xrequired: "string", xdefault: 123, z: ["string in array"])
        print(mock.result)

        mock = try await bar.put(xrequired: "string", xdefault: 123, z: ["string in array"])
        print(mock.result)

        mock = try await bar.patch(xrequired: "string", xdefault: 123, z: ["string in array"])
        print(mock.result)

        mock = try await bar.delete(xrequired: "string", xdefault: 123, z: ["string in array"])
        print(mock.result)


        // General Tests
        let result = try await general.redirect()
        print((result as! [String: Any])["result"] as! String)

        do {
            var file = InputFile.fromPath("\(FileManager.default.currentDirectoryPath)/../../resources/file.png")
            mock = try await general.upload(x: "string", y: 123, z: ["string in array"], file: file, onProgress: nil)
            print(mock.result)
        } catch let error as AppwriteError {
            print(error.message)
        }

        do {
            var file = InputFile.fromPath("\(FileManager.default.currentDirectoryPath)/../../resources/large_file.mp4")
            mock = try await general.upload(x: "string", y: 123, z: ["string in array"], file: file, onProgress: nil)
            print(mock.result)
        } catch let error as AppwriteError {
            print(error.message)
        }

        do {
            var url = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/../../resources/file.png")
            var buffer = ByteBuffer(data: try! Data(contentsOf: url))
            var file = InputFile.fromBuffer(buffer, filename: "file.png", mimeType: "image/png")
            mock = try await general.upload(x: "string", y: 123, z: ["string in array"], file: file, onProgress: nil)
            print(mock.result)
        } catch let error as AppwriteError {
            print(error.message)
        }

        do {
            var url = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/../../resources/large_file.mp4")
            var buffer = ByteBuffer(data: try! Data(contentsOf: url))
            var file = InputFile.fromBuffer(buffer, filename: "large_file.mp4", mimeType: "video/mp4")
            mock = try await general.upload(x: "string", y: 123, z: ["string in array"], file: file, onProgress: nil)
            print(mock.result)
        } catch let error as AppwriteError {
            print(error.message)
        }

        do {
            try await general.error400()
        } catch let error as AppwriteError {
            print(error.message)
        }

        do {
            try await general.error500()
        } catch {
            print(error.localizedDescription)
        }

        do {
            try await general.error502()
        } catch {
            print(String(describing: error))
        }

        wait(for: [expectation], timeout: 10.0)
        print(realtimeResponse)

        mock = try await general.setCookie()
        print(mock.result)

        mock = try await general.getCookie()
        print(mock.result)

        try! await general.empty()

        // Query helper tests
        print(Query.equal("title", value: ["Spiderman", "Dr. Strange"]));
        print(Query.notEqual("title", value: "Spiderman"));
        print(Query.lessThan("releasedYear", value: 1990));
        print(Query.greaterThan("releasedYear", value: 1990));
        print(Query.search("name", value: "john"));
        print(Query.orderAsc("title"));
        print(Query.orderDesc("title"));
        print(Query.cursorAfter("my_movie_id"));
        print(Query.cursorBefore("my_movie_id"));
        print(Query.limit(50));
        print(Query.offset(20));

        // Permission & Role helper tests
        print(Permission.read(Role.any()));
        print(Permission.write(Role.user(ID.custom("userid"))));
        print(Permission.create(Role.users()));
        print(Permission.update(Role.guests()));
        print(Permission.delete(Role.team("teamId", "owner")));
        print(Permission.delete(Role.team("teamId")));

        // ID helper tests
        print(ID.unique());
        print(ID.custom("custom_id"));
    }
}

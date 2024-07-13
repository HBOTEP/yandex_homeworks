//
//  URLSessionTests.swift
//  TodoTests
//
//  Created by Анастасия on 13.07.2024.
//

import XCTest
import CocoaLumberjackSwift

@testable import Todo

final class URLSessionTests: XCTestCase {
    func testAsyncDataTask() async throws {
        guard let url = URL(string: "https://youtu.be/dQw4w9WgXcQ?si=J7e2qvn36zGYu9nf") else { return }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.dataTask(for: urlRequest)
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
    }
    
    func testAsyncDataTaskCancellation() async {
        guard let url = URL(string: "https://youtu.be/dQw4w9WgXcQ?si=J7e2qvn36zGYu9nf") else { return }
        let urlRequest = URLRequest(url: url)
        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: urlRequest)
                XCTFail("Cancellation failed")
            } catch {
                if let error = error as? CancellationError { DDLogInfo("Task canceled") } else {
                    XCTFail("Error occurred\n\(error)")
                }
            }
        }
        task.cancel()
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch { XCTFail("Cancellation failed") }
    }
}

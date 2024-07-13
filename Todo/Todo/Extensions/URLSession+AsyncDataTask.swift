//
//  URLSession+AsyncDataTask.swift
//  Todo
//
//  Created by Анастасия on 13.07.2024.
//

import Foundation
import CocoaLumberjackSwift

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        
        return try await withTaskCancellationHandler(operation: {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                dataTask = self.dataTask(with: urlRequest) { data, response, error in
                    guard let data, let response else {
                        let error = error ?? URLError(.badServerResponse)
                        DDLogError("Error occurred while sending a request\n\(error)")
                        return continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: (data, response))
                }
                dataTask?.resume()
            }
        }, onCancel: { [weak dataTask] in
            dataTask?.cancel()
            DDLogInfo("Data task canceled")
        })
    }
}

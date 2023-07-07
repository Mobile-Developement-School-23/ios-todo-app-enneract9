//
//  URLSession extension.swift
//  To-do-list
//
//  Created by @_@ on 08.07.2023.
//

import Foundation

extension URLSession {
    func customDataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {

        return try await withCheckedThrowingContinuation({ checkedContinuation in
            let dataTask = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    checkedContinuation.resume(throwing: error)
                }

                guard let data = data, let response = response else {
                    let error = NSError(
                        domain: "URLSession",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "URLSession error: did't recieve response or data"]
                    )
                    checkedContinuation.resume(throwing: error)
                    return
                }

                DispatchQueue.main.async {
                    checkedContinuation.resume(returning: (data, response))
                }
            }

            if Task.isCancelled {
                dataTask.cancel()
            } else {
                dataTask.resume()
            }
        })
    }
}

//
//  URLSession+DataTaskProgressPublisher.swift
//  Brickie
//
//  Created by Léo on 08/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

//https://gist.github.com/T1T4N/bca1420421028c574386278753c9b7a3
#if canImport(Combine)

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension URLSession {

    public typealias DataTaskProgressPublisher =
        (progress: Progress, publisher: AnyPublisher<DataTaskPublisher.Output, Error>)

    public func dataTaskProgressPublisher(for request: URLRequest) -> DataTaskProgressPublisher {
        let progress = Progress(totalUnitCount: 1)

        let result = Deferred {
            Future<DataTaskPublisher.Output, Error> { handler in
                let task = self.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        handler(.failure(error))
                    } else if let data = data, let response = response {
                        handler(.success((data, response)))
                    }
                }

                progress.addChild(task.progress, withPendingUnitCount: 1)
                task.resume()
            }
        }

        return (progress, result.eraseToAnyPublisher())
    }

    @inlinable
    public func dataTaskProgressPublisher(for url: URL) -> DataTaskProgressPublisher {
        self.dataTaskProgressPublisher(for: .init(url: url))
    }

}

#endif //canImport(Combine)

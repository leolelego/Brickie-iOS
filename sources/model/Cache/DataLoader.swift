// Based on https://github.com/V8tr/AsyncImage/blob/master/AsyncImage/ImageLoader.swift
import Combine
import UIKit

class DataLoader: ObservableObject {
    @Published var data: Data?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: DataCache?
    private var cancellable: AnyCancellable?
    
    private static let processingQueue = DispatchQueue(label: "file-processing")
    
    init(url: URL, cache: DataCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let cacheData = cache?[url] {
            log("Data from cache  \(url.lastPathComponent)")
            self.data = cacheData
            return
        }
        log("Data Download \(url.lastPathComponent)")

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.processingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.data, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: Data?) {
        image.map { cache?[url] = $0 }
    }
}

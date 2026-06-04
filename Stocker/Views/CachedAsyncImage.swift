import SwiftUI

// MARK: - Image Cache
/// Shared in-memory image cache backed by NSCache.
/// NSCache evicts entries automatically under memory pressure.
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 200        // max entries
        cache.totalCostLimit = 50 * 1024 * 1024  // 50 MB
    }

    subscript(_ url: URL) -> UIImage? {
        get { cache.object(forKey: url.absoluteString as NSString) }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: url.absoluteString as NSString,
                                cost: Int(image.size.width * image.size.height))
            } else {
                cache.removeObject(forKey: url.absoluteString as NSString)
            }
        }
    }
}

// MARK: - Phase
enum CachedImagePhase {
    case empty
    case success(Image)
    case failure(Error)
}

// MARK: - CachedAsyncImage
/// Drop-in replacement for AsyncImage that caches images in memory.
/// Usage mirrors AsyncImage's phase-based closure API.
struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let content: (CachedImagePhase) -> Content

    @State private var phase: CachedImagePhase = .empty

    init(
        url: URL?,
        @ViewBuilder content: @escaping (CachedImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }

    var body: some View {
        content(phase)
            .task(id: url) {
                await load()
            }
    }

    private func load() async {
        guard let url else {
            phase = .failure(URLError(.badURL))
            return
        }

        // Serve from cache instantly
        if let cached = ImageCache.shared[url] {
            phase = .success(Image(uiImage: cached))
            return
        }

        phase = .empty

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            ImageCache.shared[url] = uiImage
            phase = .success(Image(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}

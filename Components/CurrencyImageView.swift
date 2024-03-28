import UIKit

final class CurrencyConverterImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    private var fetchedImage: UIImage?
    var task: URLSessionDataTask!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    
    func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        let cacheKey = NSString(string: url.absoluteString)

        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }
        task.resume()
    }
}

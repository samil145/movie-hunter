import UIKit

class MHAvatarImageView: UIImageView {
    
    let cache            = NetworkManager.shared.cache
    var placeholderImage = UIImage(named: "moviePlaceholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(image: placeholderImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage)
    {
        super.init(frame: .zero)
        configure(image: image)
    }
    
    private func configure(image: UIImage)
    {
        layer.cornerRadius = 10
        clipsToBounds = true
        self.image = image
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String)
    {
        let cacheKeyString = urlString
        
        if let image = cache.object(forKey: cacheKeyString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.contentMode = .scaleToFill
            }
            return
        }
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKeyString as NSString)
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.contentMode = .scaleToFill
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, forIndex index: Int)
    {
        let cacheKeyString = urlString
        
        self.tag = index
        
        if let image = cache.object(forKey: cacheKeyString as NSString) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.tag == index
                {
                    self.image = image
                    self.contentMode = .scaleToFill
                }
            }
            return
        }
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKeyString as NSString)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.tag == index
                {
                    self.image = image
                    self.contentMode = .scaleToFill
                }
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping () -> Void)
    {
        let cacheKeyString = urlString
        
        if let image = cache.object(forKey: cacheKeyString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.contentMode = .scaleToFill
                completed()
            }
            return
        }
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKeyString as NSString)
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.contentMode = .scaleToFill
                completed()
            }
        }
        
        task.resume()
    }
}

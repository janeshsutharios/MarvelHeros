import UIKit
import Foundation
import CommonCrypto
//MARK:- Marvel Keys
struct APIKeys {
    static let privateKey = "92b20d8b768c02a6be7c48ecb568aa60c623e7f7"
    static let publicKey = "42450c7c30ed07da81c79ddcb929343a"
}
//MARK:- Date extension
extension Date {
    
    static let shared = Date()
    
    func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toMillisString() -> String {
        return String(toMillis())
    }
}
//MARK:- String extension
extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    //MD5 string conversion for Marvel API
    var MD5: String? {
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

//Lazy loading of UIImage
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

//MARK:- Loader
extension UIViewController {

    func showIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.tag = 100
        activityIndicator.color = .red
        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: true)
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
}

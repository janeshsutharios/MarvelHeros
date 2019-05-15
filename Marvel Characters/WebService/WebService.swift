import UIKit
import Foundation

struct WebService {
    static let baseURL = "https://gateway.marvel.com/v1/public/"
    static func fetchData(url: URL,httpMethod: HttpMethod, parameters:[String:Any],completion:@escaping(Data)->Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod == .get ? "GET" : "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if data != nil {
                DispatchQueue.main.async {
                    completion(data!)
                }
            } else {
                completion(Data())
            }
        })
        task.resume()
    }
}

enum HttpMethod {
    case get
    case post
}

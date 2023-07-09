//
//  HomeScreenParser.swift
//  ShopNow
//
//  Created by mayank ranka on 01/07/23.
//

import UIKit

protocol ProductsParserDelegate: NSObjectProtocol {
    func didReceivedProducts(products: [ProductsModel])
    func didReceivedError()
}

class ProductsParser: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var webData : Data?
    weak var delegate : ProductsParserDelegate?
    
    var session : URLSession{
        let defualtConfig = URLSessionConfiguration.default
        defualtConfig.requestCachePolicy =  NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let session1 = URLSession(configuration: defualtConfig, delegate: self, delegateQueue: nil)
        return session1
    }
    
    func getProductsDetails() {
        var urlComponents = URLComponents(string: "\(AppConstant.BASE_URL)products")
        urlComponents?.queryItems = [ URLQueryItem(name: "limit", value: "100") ]
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
    //https://dummyjson.com/products/category/smartphones
    
    func getProductsDetails(category: String){
        let url = URL(string: "\(AppConstant.BASE_URL)products/category/\(category)")
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            webData = try Data(contentsOf: location)
            
            let responseString = String(data: webData!, encoding: String.Encoding.utf8)
            print("responseString \(responseString!)")
            
            let jsonConvert = try JSONSerialization.jsonObject(with: webData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
            let data = jsonConvert["products"] as! [[String : Any]]
            var products : [ProductsModel] = []
            for i in 0..<data.count {
                let product = ProductsModel(ditionary: data[i])
                products.append(product)
            }
            DispatchQueue.main.async {
                self.delegate?.didReceivedProducts(products: products)
            }
        }catch{
            delegate?.didReceivedError()
            print("Product Parser Error")
            
        }
    }
}


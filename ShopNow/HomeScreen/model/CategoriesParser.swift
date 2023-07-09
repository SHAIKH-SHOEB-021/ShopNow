//
//  CategoriesParser.swift
//  ShopNow
//
//  Created by mayank ranka on 03/07/23.
//

import UIKit


protocol CategoriesParserDelegate: NSObjectProtocol {
    func didReceivedCategorys(categorys: [String])
    func didReceivedError()
}

class CategoriesParser: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var webData : Data?
    weak var delegate : CategoriesParserDelegate?
    
    var session : URLSession{
        let defualtConfig = URLSessionConfiguration.default
        defualtConfig.requestCachePolicy =  NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let session1 = URLSession(configuration: defualtConfig, delegate: self, delegateQueue: nil)
        return session1
    }

    func getCategorysDetail(){
        let url = URL(string: "\(AppConstant.BASE_URL)products/categories")
        let task = session.downloadTask(with: url!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            webData = try Data(contentsOf: location)
            
            let responseString = String(data: webData!, encoding: String.Encoding.utf8)
            print("responseString \(responseString!)")
            
            let jsonConvert = try JSONSerialization.jsonObject(with: webData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String]
            let categorys : [String] = jsonConvert
            
            DispatchQueue.main.async {
                self.delegate?.didReceivedCategorys(categorys: categorys)
            }
        }catch{
            delegate?.didReceivedError()
            print("Product Parser Error")
            
        }
    }

}

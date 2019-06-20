//
//  FlickerAPI.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 12/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import Foundation
class FlickrAPI {


    static func getFlickrImages(lat: Double, lng: Double, completion: @escaping (_ success: Bool, _ flickrImages:[URL]?,Error?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=6b0522500f1f5cc129fbb5441950997b&lat=\(lat)&lon=\(lng)&radius=15&nojsoncallback=1&safeSearch=1&extras=url_m")!)

        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { data, response, error in

            if error != nil {
                print("error1")

                completion(false, nil,error)
                return
            }

            guard let stauts = (response as? HTTPURLResponse)?.statusCode, stauts <= 200 && stauts <= 299 else {
                print("error2")

                completion(false, nil,nil)
                return
            }

            guard let data = data else {
                print("error3")

                completion(false, nil,nil)
                return
            }
            print(String(data:data,encoding: .utf8))

            guard let result = try? JSONSerialization.jsonObject(with: data, options: [])as![String:
                Any] else {
                print("error4")
                completion(false, nil,nil)
                return
            }
            guard let stat = result["stat"] as? String , stat == "ok" else {
                print("error5")
                completion(false, nil,nil)
                return
            }

            guard let photosDic = result["photos"] as? [String:Any] else {
                print("error6")
                completion(false, nil,nil)
                return
            }

            guard let photoArray = photosDic["photo"] as? [[String:Any]] else {
                print("error7")
                completion(false, nil,nil)
                return
            }

            let photosURLs = photoArray.compactMap { photosDic -> URL? in guard let
                url = photosDic["url_m"] as? String else {
                print("error8")

                return nil}
                return URL(string: url)
            }
            
            completion(true, photosURLs,nil)
        }

        task.resume()
    }
    
}



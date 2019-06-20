//
//  File.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 15/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit
protocol CustomImage {
    func imagedDawnloaded()
}

let imageCach = NSCache<NSString,AnyObject>()
class custumImage:UIImageView{
    var photoUrl:URL!

    func setPhoto(_ Newphoto:Photo){
        if photo != nil {
            return
        }
        photo = Newphoto
    }
    private var photo: Photo!{
        didSet{
            if let image = photo.getImage(){
                self.image = image
                return
            }
            guard let url = photo.url else{
                return
            }
            loadImageUsingCache(with:url)
        }
    }

    func loadImageUsingCache (with url:URL){
        photoUrl = url
        image = nil
        showActivityIndicatorView()
        if let cachedImaged = imageCach.object(forKey: url.absoluteString as NSString) as? UIImage{
            image = cachedImaged
            hideActivityIndicatorView()
            return
        }
        URLSession.shared.dataTask(with: url){(data, response, error)in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let downloadImage = UIImage(data: data!) else {return}
            imageCach.setObject(downloadImage, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image=downloadImage
                self.photo.set(image: downloadImage)
                try? self.photo.managedObjectContext?.save()
                self.hideActivityIndicatorView()
            }
            }.resume()
    }
    lazy var activityInicator: UIActivityIndicatorView = {
        let activityInicator = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityInicator)
        activityInicator.translatesAutoresizingMaskIntoConstraints = false
        activityInicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
        activityInicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        activityInicator.color = .black
        activityInicator.hidesWhenStopped=true
        return activityInicator

    }()
    func hideActivityIndicatorView(){
        DispatchQueue.main.async {
            self.activityInicator.stopAnimating()
        }
    }
    func showActivityIndicatorView(){
        DispatchQueue.main.async {
            self.activityInicator.startAnimating()
        }
    }

}


//
//  photoEx.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 12/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit

extension Photo {
    func set(image: UIImage){
self.image = image.pngData()
    }

    func getImage()-> UIImage? {
        return (image==nil) ? nil : UIImage(data:image!)
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        date=Date()
    }
}

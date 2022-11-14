//
//  ImageViewController.swift
//  GrandCentralDispach
//
//  Created by Александр Коробицын on 12.11.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    let content = UIImageView()
    let activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    
    var imageURL: URL?
    var image: UIImage? {
        get {
            return content.image
        }
        set {
            content.image = newValue
            content.contentMode = .scaleAspectFill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceViews()
        fetchImage()
    }
    
    private func instanceViews() {
        view.addSubview(content)
        content.addSubview(activityIndicator)
        content.frame = UIScreen.main.bounds
        content.backgroundColor = UIColor.lightGray.withAlphaComponent(1)
        activityIndicator.frame = UIScreen.main.bounds
        activityIndicator.color = UIColor.black
    }
    
    private func fetchImage() {
        imageURL = URL(string: "https://media1.popsugar-assets.com/files/thumbor/-Hw_8s42nZxSC65rDGpzyMzA_cA/0x600:2401x3001/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2022/01/04/686/n/1922507/6023a31161d467cac500f9.25034761_/i/how-to-do-planet-iphone-wallpaper-trend-tiktok.jpg")
        
        activityIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else {return}
            
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

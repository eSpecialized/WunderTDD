//
//  DetailViewController.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit
import SwiftyGif

class WWeatherDetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var weatherMapView: UIImageView!
    
    let fWeatherAPI = WWunderAPI()
    let fGifManager = SwiftyGifManager(memoryLimit: 20)

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = "Conditions: " +  detail.conditions!
            }
            
            self.title = detail.cityState
            
//            fWeatherAPI.fetchRadarAndSatGifData(inCity: detail.city!, inState: detail.state!, completion: { [unowned self] (data, error) in
//
//                if let data = data {
//                    let gifImg = UIImage.init(gifData: data)
//                    self.weatherMapView.setGifImage(gifImg, manager: self.fGifManager)
//                }
//            })
         fWeatherAPI.fetch( type: .kWeatherSatelliteHybridMap , city: detail.city!, state: detail.state!, completion: { [unowned self] (data, error) in
            
            if let data = data {
               let gifImg = UIImage.init(gifData: data)
               self.weatherMapView.setGifImage(gifImg, manager: self.fGifManager)
            }
         })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}


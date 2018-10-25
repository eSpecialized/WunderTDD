//
//  DetailViewController.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit
import SwiftyGif
import RxSwift
import RxCocoa

class WWeatherDetailViewController: UIViewController {
    
    let bag = DisposeBag()

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var weatherMapView: UIImageView!
    
    let fWeatherAPI = WWunderAPI()
    let fGifManager = SwiftyGifManager(memoryLimit: 20)

    func configureView() {
        guard let detail = detailItem,
            let city = detail.city,
            let state = detail.state
            else { return }
        if let label = detailDescriptionLabel,
            let conditions = detail.conditions {
            label.text = "Conditions: " + conditions
        }
            
        self.title = detail.cityState

        fWeatherAPI.fetchMap(type: .kWeatherSatelliteHybridMap, city: city, state: state)
            .subscribe(onNext: { [weak self] in
                self?.weatherMapView.setGifImage($0, manager: self!.fGifManager)
            })
            .disposed(by: bag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var detailItem: Event? {
        didSet {
            configureView()
        }
    }

}

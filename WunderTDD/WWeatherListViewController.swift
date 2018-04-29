//
//  MasterViewController.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit
import CoreData
import SwiftyGif
import RxSwift
import RxCocoa


class WWeatherListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  
  @IBOutlet weak var configButton: UIBarButtonItem!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
    let bag = DisposeBag()

    var detailViewController: WWeatherDetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    let fWeatherAPI = WWunderAPI()
    
    let fGifManager = SwiftyGifManager(memoryLimit: 20)

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton1 = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton1
        self.addButton = addButton1
        addButton1.rx
        .tap
        .debounce(0.3, scheduler: MainScheduler.instance) //filter all but last event
        .bind( onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            print("Add button tapped")
            let alertAdd = UIAlertController(title: "Add Location", message: "City, ST format", preferredStyle: .alert)
            
            alertAdd.addTextField { (textField) in
                textField.placeholder = "City, ST"
            }
            
            let actionOk = UIAlertAction(title: "Ok", style: .default) {  (action) in
                
                if let cityState = alertAdd.textFields?.first?.text {
                    strongSelf.insertNewObject(cityState)
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertAdd.addAction(actionOk)
            alertAdd.addAction(actionCancel)
            
            strongSelf.present(alertAdd, animated: true, completion: nil)
            })
        .disposed(by: bag)
      
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? WWeatherDetailViewController
        }
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refreshControl = UIRefreshControl()
        guard let refreshControl1 = refreshControl else { return }
        let didPullToRefresh: Observable<Void> =  refreshControl1.rx.controlEvent(.valueChanged)
        .map { refreshControl2 in
            return refreshControl1.isRefreshing
        }
        .filter { $0 == true }
        .map { [weak self] _ in
            return ()
        }
      
        didPullToRefresh
        .subscribe({ [weak self] _ in
            self?.refreshControl?.beginRefreshing()
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        })
        .disposed(by: bag)
      
      
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc
    func insertNewObject(_ cityState: String) {
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
             
        // If appropriate, configure the new managed object.
        newEvent.timestamp = Date()
        newEvent.cityState = cityState
        newEvent.conditions = "..."
        newEvent.realFeelC = 0
        newEvent.realFeelF = 0
        newEvent.temperatureF = 0
        newEvent.temperatureC = 0
        newEvent.city = "..."
        newEvent.state = "..."
        newEvent.windMPH = 0
        
        let comps = cityState.components(separatedBy: CharacterSet.punctuationCharacters)
        
        newEvent.city = comps.first!
        let trimState = comps.last!.trimmingCharacters(in: CharacterSet.whitespaces)
        newEvent.state = trimState
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! WWeatherDetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WWeatheTableViewCell
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        updateCell2(cell, withEvent: event)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

  func updateCell2(_ cell: WWeatheTableViewCell, withEvent event: Event) {

      fWeatherAPI.fetch( type: .kWeather, city: event.city!, state: event.state!)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { weatherStruct in

            event.temperatureF = weatherStruct.currentObservation.temp_f
            event.conditions = weatherStruct.currentObservation.currentWeatherString
            event.windMPH = weatherStruct.currentObservation.wind_mph
            event.icon = weatherStruct.currentObservation.icon
            
            let context = self.fetchedResultsController.managedObjectContext
            do {
              try context.save()
            } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            self.configureCell(cell, withEvent: event)
          
        },
          onError: { error in
            print(error)
        }
//            ,
//          onCompleted: { print("onCompleted") },
//          onDisposed: { print("onDisposed") }
          )
       .disposed(by: bag)
    }


    
    
    func showAlert( title: String, message: String)
    {
        let alertAdd = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertAdd.addAction(actionOk)
        
        present(alertAdd, animated: true, completion: nil)
    }

    func configureCell(_ cell: WWeatheTableViewCell, withEvent event: Event) {

        cell.location.text = event.cityState
        cell.wind.text = "Wind: " + String(event.windMPH) + "MPH"
        cell.temperature.text = String(event.temperatureF) + "F"
        cell.conditions.text = event.conditions!
        
        if let icon = event.icon {
            if icon == "..." {
                return
            }
            
            fWeatherAPI.fetchIconData(icon: icon, completion: { [unowned self] (data, error) in
                
                //this library crashes. so looking else where for icons
                if let data = data {
                    let gifImg = UIImage.init(gifData: data)
                    cell.icon.setGifImage(gifImg, manager: self.fGifManager)
                }
            })
        }
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)! as! WWeatheTableViewCell, withEvent: anObject as! Event)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! WWeatheTableViewCell, withEvent: anObject as! Event)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}


//
//  ViewController.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 23/09/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController , MKMapViewDelegate , NSFetchedResultsControllerDelegate  {

    var fetch : NSFetchedResultsController<Pin>!
    var context: NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupfetch()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupfetch()

    }

    func setupfetch() {
        let fetchReq: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchReq.sortDescriptors = [
            NSSortDescriptor(key:"date",ascending: false)]
        fetch = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    fetch.delegate = self
        do {
            try fetch.performFetch()
            updateMap()
        }catch {
            fatalError("can't preforme fetch:(")
        }
        }

    func updateMap(){
        guard let pins = fetch.fetchedObjects  else {
            return
        }
        for pin in pins {
            if map.annotations.contains(where:{pin.compare(to: $0.coordinate)}){continue}
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinates
            map.addAnnotation(annotation)
        }
    }


    @IBAction func longPressMethod(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {return}
        let touchPoint = sender.location(in: map)
        let pin = Pin(context: context)
        pin.coordinates = map.convert(touchPoint, toCoordinateFrom: map)
        try?context.save()
    }
  
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetch.fetchedObjects?.filter{
            $0.compare(to: view.annotation!.coordinate)}.first!
        performSegue(withIdentifier: "showPhoto", sender: pin)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       updateMap()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photo = segue.destination as! CollectionViewController
        photo.pin=sender as! Pin
    }

}


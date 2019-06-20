//
//  CollectionViewController.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 12/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController , NSFetchedResultsControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var NoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func NewCollectionOnClick(_ sender: Any) {
        updateUI(processing:true)
        if haveImage{
            isDeletingall=true
            for photo in fetchedController.fetchedObjects!{
                context.delete(photo)
            }
            try? context.save()
            isDeletingall=false
        }

        var x = pin.coordinates.latitude

        FlickrAPI.getFlickrImages(lat: pin.coordinates.latitude, lng: pin.coordinates.longitude){
            (error , urls ,Error) in
            DispatchQueue.main.async{
                self.updateUI(processing:false)
                guard (Error==nil)  else {
                    print(error)
                    print ("there is an errorrrr!")
                   let errorMessage = Error?.localizedDescription
                   print(errorMessage ?? "")
                    
                    let alert = UIAlertController(title:"", message: "\(errorMessage ?? "")", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        
                    }))
                    
                    
                    
                    self.present(alert, animated: true)
                    
                    return

        
                }

                guard let urls=urls, !urls.isEmpty else{
                    self.NoLabel.isHidden=false
                    return
                }

                for url in urls{
                    let photo = Photo(context:self.context)
                    photo.url=url
                    photo.pin=self.pin
                }
                try?self.context.save()
            }
        }
        self.pageNumber += 1
    }

    func updateUI(processing:Bool){
        collectionView.isUserInteractionEnabled = !processing
        if processing{
            newCollectionButton.title=""
            activityIndicator.isHidden=false
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden=true
            newCollectionButton.title="new Collection"
        }
    }



    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedController=nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NoLabel.isHidden=true
        // Do any additional setup after loading the view.
    }
    
    var pin : Pin!
    var fetchedController:NSFetchedResultsController<Photo>!
    var pageNumber=1
    var isDeletingall=false
    var context:NSManagedObjectContext{
        return DataController.sharedInstance.viewContext
    }
    var haveImage: Bool{
        return (fetchedController.fetchedObjects?.count ?? 0) != 0
    }


    func setupFetchedResultsController(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate=NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedController=NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate = self
        do{
            try fetchedController.performFetch()
            if haveImage{
                updateUI(processing:false)
            }
            else {
                NewCollectionOnClick(self)
            }


        } catch{
            fatalError("Error10")
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedController.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as!CollectionViewCell
        let photo = fetchedController.object(at: indexPath)
        cell.image.setPhoto(photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.fetchedController.object(at: indexPath)
        let alert = UIAlertController(title:"what do want to do ?", message: "", preferredStyle: .alert)


        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in


            self.context.delete(photo)
            try? self.context.save()

        }))

        alert.addAction(UIAlertAction(title: "open", style: .default, handler: {
            action in
            let url1 = self.fetchedController.object(at: indexPath).url
            UIApplication.shared.open(url1!)


        }))

        self.present(alert, animated: true)



    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if let new = newIndexPath, let old = indexPath, type == .move {
            collectionView.moveItem(at: old, to: new)
            return
        }

        if let indexPath = indexPath, type == .delete && !isDeletingall{
            collectionView.deleteItems(at: [indexPath])
            return
        }

        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }

        if type != .update {
            collectionView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.width/3
        return CGSize(width: length,height: length)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
}

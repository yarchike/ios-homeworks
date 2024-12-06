//
//  LikeTableViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//

import UIKit
import StorageService
import CoreData

class LikeTableViewController: UITableViewController {
    

    
    lazy var fetchedResultController: NSFetchedResultsController = {
        
        let request = LikePost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "views", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: LikeDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellId)
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(filterPressed))
        let clearFilterButton = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .plain, target: self, action: #selector(cleraFilterPressed))
        self.navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
        
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
    }
    
    
    @objc func filterPressed() {
        TextPicker.showMessageFilter(in: self){text in
            self.fetchedResultController.fetchRequest.predicate =  NSPredicate(format: "author CONTAINS[c] %@", text)
            
            try? self.fetchedResultController.performFetch()
            self.tableView.reloadData()
        }
        
    }
    
    @objc func cleraFilterPressed() {
        self.fetchedResultController.fetchRequest.predicate = nil
        try? self.fetchedResultController.performFetch()
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? .zero
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.cellId,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        let likesPost = fetchedResultController.object(at: indexPath)
        //cell.update(with: likesPost)
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let likePost = fetchedResultController.object(at: indexPath)
            LikeDataManager.shared.deleteLikePost(likePost: likePost){ [weak self] in
                
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LikeTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadData()
        @unknown default:
            fatalError()
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

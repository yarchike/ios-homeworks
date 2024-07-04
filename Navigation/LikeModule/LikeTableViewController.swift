//
//  LikeTableViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//

import UIKit
import StorageService

class LikeTableViewController: UITableViewController {
    
    
    var likePosts = [LikePost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellId)
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(filterPressed))
        let clearFilterButton = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .plain, target: self, action: #selector(cleraFilterPressed))
        self.navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    func updateUI() {
        likePosts = LikeDataManager.shared.getLikePost()
        self.tableView.reloadData()
        
    }
    @objc func filterPressed() {
        TextPicker.showMessageFilter(in: self){text in 
            self.likePosts = LikeDataManager.shared.getLikeFilterPost(author: text )
            self.tableView.reloadData()
        }
        
    }
    
    @objc func cleraFilterPressed() {
        self.likePosts = LikeDataManager.shared.getLikePost()
        self.tableView.reloadData()
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likePosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.cellId,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.update(likePosts[indexPath.row])
        
        return cell
    }

    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LikeDataManager.shared.deleteLikePost(likePost: likePosts[indexPath.row]){ [weak self] in
                
                DispatchQueue.main.sync {
                
                    self?.likePosts = LikeDataManager.shared.getLikePost()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
               
            }
            //likePosts =  LikeDataManager.shared.getLikePost()
    
            //
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

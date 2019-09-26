//
//  HistoryViewController.swift
//  octopus-reader
//
//  Created by CHAN Hong Wing on 26/9/2019.
//  Copyright © 2019 CHAN Hong Wing. All rights reserved.
//

import UIKit
import CoreData

class HistoryCell: UITableViewCell{
    
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var date: UILabel!
    
}

class HistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    
    var records: [Records] = []
    var fetchResultController: NSFetchedResultsController<Records>!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch data from data store
        let fetchRequest: NSFetchRequest<Records> = Records.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "create_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            
            do {
                try self.fetchResultController.performFetch()
                if let fetchedObjects = self.fetchResultController.fetchedObjects {
                    records = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "historyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryCell
        
        // Configure the cell...
        cell.balance?.text = "\(records[indexPath.row].balance)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " HH:mm:ss dd-MM-yyyy"
        
        cell.date?.text = "\( dateFormatter.string(from: records[indexPath.row].create_date!))"
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

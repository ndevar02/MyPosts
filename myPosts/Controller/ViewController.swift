//
//  ViewController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 24/12/21.
//

import UIKit

class TableViewCell : UITableViewCell {

   
    @IBOutlet weak var lblDesrciption: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!
}


class ViewController: UIViewController {

    var jsonArray = [JsonData]()

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var tblMyPosts: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblMyPosts.delegate = self
        tblMyPosts.dataSource = self
        
        var service = JsonService()
        service.delegate = self
       service.performService()
        
            
        tblMyPosts.rowHeight = UITableView.automaticDimension
        tblMyPosts.estimatedRowHeight = 100
        activitySpinner.startAnimating()
        activitySpinner.hidesWhenStopped = true
        
       
        
    }
    
    


}


extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView,
                      trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
       {
           // Write action code for the trash
           let TrashAction = UIContextualAction(style: .normal, title:  "Swipe to Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               let alert = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete the record", preferredStyle: UIAlertController.Style.alert)
               let yesAction = UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in
                   self.jsonArray.remove(at: indexPath.row)
                   self.tblMyPosts.reloadData()
                

               })
               alert.addAction(yesAction)
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
               
               
               success(true)
           })
           TrashAction.backgroundColor = .red

          

           return UISwipeActionsConfiguration(actions: [TrashAction])
       }
    
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.lblTitle.text = jsonArray[indexPath.row].title
        cell.lblId.text = String(jsonArray[indexPath.row].id)
        cell.lblDesrciption.text = jsonArray[indexPath.row].body
       
        
        return cell
    }
    
  
   
}

extension ViewController : JsonDataDelegate {
    func updateData(jsonDataArray: [JsonData]) {
        print("i am in delegate method")
        jsonArray = jsonDataArray
        DispatchQueue.main.async {
            
            self.tblMyPosts.reloadData()
            self.activitySpinner.stopAnimating()
            
        }
       
    }

}

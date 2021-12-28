//
//  ViewController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 24/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    var jsonArray = [JsonData]()
    var service = JsonService()
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var tblMyPosts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblMyPosts.delegate = self
        tblMyPosts.dataSource = self
        service.delegate = self
        service.getJsonData { error in
            if error != nil {
                ExceptionHandler.printError(message: error!.localizedDescription)
            }
        }

        tblMyPosts.rowHeight = UITableView.automaticDimension
        tblMyPosts.estimatedRowHeight = 200
        activitySpinner.startAnimating()
        activitySpinner.hidesWhenStopped = true
        
    }
    

    @IBAction func goToAddScreen(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "AddScreen", sender: sender)
        
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
    }
}


extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .normal, title:  "Swipe to Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in
                
                self.service.deleteJsonData(id:indexPath.row) { (error) in
                    if let err = error{
                        print(err)
                    }
                }
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
        cell.lblId.text =  String(jsonArray[indexPath.row].id)
        cell.cellDelegate = self
        cell.index = jsonArray[indexPath.row].id
        cell.lblDescription.text =  jsonArray[indexPath.row].body
        
        return cell
    }
    
    
    
}

extension ViewController : JsonDataDelegate {
    func updateData(jsonDataArray: [JsonData]) {
        
        jsonArray = jsonDataArray
        DispatchQueue.main.async {
            
            self.tblMyPosts.reloadData()
            self.activitySpinner.stopAnimating()
            
        }
        
    }
    
}
extension ViewController : TableCellEdit{
    func editData(index: Int) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let editAdd = storyBoard.instantiateViewController(withIdentifier: "EditAddController") as! EditAddController
        
        self.navigationController?.pushViewController(editAdd, animated: true)
    }
    
    
}

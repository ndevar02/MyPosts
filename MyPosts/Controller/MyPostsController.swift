//
//  ViewController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 24/12/21.
//

import UIKit

class MyPostsController: UIViewController {
    
    private var myPosts = [MyPostResponse]()
    private let mypostService = MyPostServiceClass()
    
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var tblMyPosts: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tblMyPosts.delegate = self
        tblMyPosts.dataSource = self
        
        tblMyPosts.rowHeight = UITableView.automaticDimension
        tblMyPosts.estimatedRowHeight = 200
        activitySpinner.startAnimating()
        activitySpinner.hidesWhenStopped = true
        performMyPostsService()

    }
    

    private func performMyPostsService()
    {
        mypostService.getMyPosts { myPostArray, error in
            if myPostArray!.count > 0 {
                DispatchQueue.main.async {
                    self.myPosts = myPostArray!
                    print("in SERVICE before reload")
                    self.tblMyPosts.reloadData()
                    self.tblMyPosts.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    self.activitySpinner.stopAnimating()
                    
                }
            }
            
        }
    }
    
    
    
    
    @IBAction func goToAddScreen(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "AddScreen", sender: sender)
        
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        performMyPostsService()
        
    }
}


extension MyPostsController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .normal, title:  "Swipe to Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in
                
               
                self.mypostService.deleteMyPosts(id:indexPath.row) {  (response,error) in
                    if let err = error {
                        ExceptionHandler.printError(message: err.localizedDescription)
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.myPosts.remove(at: indexPath.row)
                            self.tblMyPosts.reloadData()
                            
                        }
                    }
                }
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
extension MyPostsController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPostTableCell
        cell.lblTitle.text = myPosts[indexPath.row].title
        cell.lblId.text =  String(myPosts[indexPath.row].id!)
        cell.cellDelegate = self
        cell.jsonDataToBeEdited = myPosts[indexPath.row]
        cell.lblDescription.text =  myPosts[indexPath.row].body
        
        return cell
    }
    
}

extension MyPostsController : MyPostTableCellDelegate{
    
    func myPostsEditData(myPostsDataToBeEdited: MyPostResponse?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let editAdd = storyBoard.instantiateViewController(withIdentifier: "EditAddController") as! EditAddController
        editAdd.isEdit = true
        if let myPostsDataToBeEdited = myPostsDataToBeEdited {
            editAdd.myPostsDataToBeEdited = myPostsDataToBeEdited
        }
        self.navigationController?.pushViewController(editAdd, animated: true)
    }
    
}

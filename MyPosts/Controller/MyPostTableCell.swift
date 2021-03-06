//
//  TableViewCell.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.


import UIKit

protocol MyPostTableCellDelegate{
    func myPostsEditData(myPostsDataToBeEdited : MyPostResponse?)
}

class MyPostTableCell: UITableViewCell {
    
    public var cellDelegate : MyPostTableCellDelegate?
    public var jsonDataToBeEdited : MyPostResponse?
    
    @IBAction func myPostsClickToEdit(_ sender: Any) {
        cellDelegate?.myPostsEditData(myPostsDataToBeEdited: jsonDataToBeEdited)
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!

}

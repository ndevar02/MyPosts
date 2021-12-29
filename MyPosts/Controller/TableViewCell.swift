//
//  TableViewCell.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.
//

import UIKit

protocol TableCellEdit{
    func editData(jsonDataToBeEdited : JsonData?)
}

class TableViewCell: UITableViewCell {
    
    var cellDelegate : TableCellEdit?
   
    var jsonDataToBeEdited : JsonData?
    var controller = self
    
    
    @IBAction func clickMeToEdit(_ sender: Any) {
        cellDelegate?.editData(jsonDataToBeEdited: jsonDataToBeEdited)
        
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!
    
    
}

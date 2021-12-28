//
//  TableViewCell.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.
//

import UIKit

protocol TableCellEdit{
    func editData(index : Int)
}

class TableViewCell: UITableViewCell {
    
    var cellDelegate : TableCellEdit?
    var index = 0
    var controller = self
    
    @IBAction func clickMeToEdit(_ sender: Any) {
        cellDelegate?.editData(index: index)
        
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!

    
}

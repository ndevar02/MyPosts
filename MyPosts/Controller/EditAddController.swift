//
//  EditAndAddController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.
//

import UIKit

class EditAddController: UIViewController {
    
    @IBOutlet weak var txtTileCharacter: UILabel!
    
    @IBOutlet weak var txtDescriptionCharacter: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var btnExit: UIButton!
    
    
    @IBOutlet weak var lblId: UILabel!
    var isEdit = false
    var editData : JsonData?
    
    override func viewDidLoad() {
        txtTitle.delegate = self
        txtDescription.delegate = self
        super.viewDidLoad()
        if isEdit == true {
            showEdit()
        }
        // Do any additional setup after loading the view.
    }
    
    
    private func showEdit() {
        //btnExit.isHidden = true
        txtTitle.text = editData?.title
        txtTitle.isScrollEnabled = true
        
        txtDescription.text = editData?.body
        txtDescription.isScrollEnabled = true
        lblId.text = String(editData!.id)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EditAddController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        print(textView.tag)
        
        if textView.tag == 1 {
            
            txtTileCharacter.text = "character count : " + String(textView.text.count)
        }
        else
        {
            txtDescriptionCharacter.text = "character count : " + String(textView.text.count)
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Its backspace
        if text == ""
        {
            
            
            return true
        }
        else {
            if textView.tag == 1 {
                let numberOfChars = textView.text.count // for Swift use count(newText)
                return numberOfChars < 80;
            }
            else
            {
                let numberOfChars = textView.text.count // for Swift use count(newText)
                return numberOfChars < 150;
            }
        }
    }
    
}

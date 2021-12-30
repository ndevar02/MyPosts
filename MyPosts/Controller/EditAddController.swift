//
//  EditAndAddController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.
//

import UIKit

class EditAddController: UIViewController {
    
    
    @IBAction func updateAndSave(_ sender: UIButton) {
        
       
        let service = JsonService()
        
        if (sender.title(for: .normal)!) == "Save"{
            print("in save")
            service.createJsonData(title: txtTitle.text!, description: txtDescription.text!) { error in
                
                if error == nil {
                    DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    ExceptionHandler.printError(message: error!.localizedDescription)
                }
            }
            
        }
        else {
            
            
            service.updateJsonData(id: Int(lblId.text!) ?? 0, title: txtTitle.text!, description: txtDescription.text!) { error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else
                {
                    ExceptionHandler.printError(message: error!.localizedDescription)
                }
            }
            
        }
    }
    
    @IBOutlet weak var btnSaveAndUpdate: UIButton!
    @IBOutlet weak var viewId: UIView!
    @IBOutlet weak var lblScreen: UILabel!
    
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
        else
        {
            saveButton()
        }
        // Do any additional setup after loading the view.
    }
    
    private func saveButton(){
        lblScreen.text = "Save"
        btnSaveAndUpdate.setTitle("Save", for: .normal)
        btnExit.isHidden = false
        txtTitle.text = ""
        txtDescription.text = ""
        viewId.isHidden = true
        
        
        
    }
    
    private func showEdit() {
        
        txtTitle.text = editData?.title
        txtTitle.isScrollEnabled = true
        btnExit.isHidden = true
        
        txtDescription.text = editData?.body
        txtDescription.isScrollEnabled = true
        lblId.text = String(editData!.id)
        lblScreen.text = "EDIT"
        btnSaveAndUpdate.setTitle("Update", for: .normal)
        
    }
    
    
}

extension EditAddController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
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

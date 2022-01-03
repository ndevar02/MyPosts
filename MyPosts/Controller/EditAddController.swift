//
//  EditAndAddController.swift
//  myPosts
//
//  Created by Nithya Devarajan on 28/12/21.
//

import UIKit

class EditAddController: UIViewController {

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
        isEdit ? showEdit() : saveButton()

    }
    
    private func saveButton(){
        lblScreen.text = "Save"
        btnSaveAndUpdate.setTitle("Save", for: .normal)
        btnExit.isHidden = false
        txtTitle.text = ""
        txtDescription.text = ""
        viewId.isHidden = true
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction))

                self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
  
    
    private func showEdit() {
        
        self.title = "Edit"
        txtTitle.text = editData?.title
        txtTitle.isScrollEnabled = true
        btnExit.isHidden = true
        txtDescription.text = editData?.body
        txtDescription.isScrollEnabled = true
        lblId.text = String(editData!.id)
        lblScreen.text = "EDIT"
        btnSaveAndUpdate.setTitle("Update", for: .normal)
        txtTileCharacter.text = String(editData!.title.count) + "/80"
        txtDescriptionCharacter.text = String (editData!.body.count) + "/150"
        
    }
    @IBAction func updateAndSave(_ sender: UIButton) {

        let service = JsonService()
        
        if !isEdit {
            service.createJsonData(title: txtTitle.text!, description: txtDescription.text!) { data in
                
                if data != nil {
                    DispatchQueue.main.async {
                        print(String(data:data!,encoding:.utf8))
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else
                {
                    ExceptionHandler.printError(message: "error in create data")
                }
            }
            
        }
        else {

            service.updateJsonData(id: Int(lblId.text!) ?? 0, title: txtTitle.text!, description: txtDescription.text!) { data in
                
                if data != nil {
                    DispatchQueue.main.async {
                        print("in update")
                        print(String(data:data!,encoding:.utf8))
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                else
                {
                    ExceptionHandler.printError(message: "error in update data")
                }
            }
            
        }
    }
    
}

extension EditAddController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
      
        
        if textView == txtTitle{
            
            txtTileCharacter.text = String(textView.text.count)+"/80"
        }
        else
        {
            txtDescriptionCharacter.text = String(textView.text.count) + "/150"
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
        // Its backspace
        if text == ""
        {
            
            return true
        }
        else {
            if textView == txtTitle {
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

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
        if sender.title(for: .normal)! == "SAVE"{
            print("in save")
            service.createJsonData(title: txtTitle.text!, description: txtDescription.text!) { error in
                print(error)
            }
            //self.performSegue(withIdentifier: "unwindToSegue", sender: self)
        }
        else {
            
            print("edit")
            service.updateJsonData(id: Int(lblId.text!) ?? 0, title: txtTitle.text!, description: txtDescription.text!) { error in
                print(error)
            }
            self.navigationController?.popViewController(animated: true)
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

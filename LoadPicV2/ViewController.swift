//
//  ViewController.swift
//  LoadPicV2
//
//  Created by Rick Mc on 1/27/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var textFieldT : UITextField!
    @IBOutlet weak var textFieldB : UITextField!
    
    struct Meme {
        
        var topTextField: String?
        var bottomTextField: String?
        var originalImage: UIImage?
        let memedImage: UIImage!
    }

let memeTextAttributes:[String:Any] = [
    NSStrokeColorAttributeName: UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
    NSStrokeWidthAttributeName: -3.0 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldT.defaultTextAttributes = memeTextAttributes
        textFieldB.defaultTextAttributes =
            memeTextAttributes
        
        textFieldT.backgroundColor = .clear
        textFieldB.backgroundColor = .clear
        textFieldT.textColor = .white
        textFieldB.textColor = .white
        textFieldT.textAlignment = .center
        textFieldB.textAlignment = .center
        textFieldT.delegate = self
        textFieldB.delegate = self
        textFieldT.text = "TOP"
        textFieldB.text = "BOTTOM"
        // Do any additional setup after loading the view, typically from a nib.
            dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    @IBAction func pickImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { imagePickView.image = image }
        self.dismiss(animated: true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
func saveMeme() {
//    Create the meme
    _ = Meme(topTextField: textFieldT.text!, bottomTextField: textFieldB.text!, originalImage:
    imagePickView.image!, memedImage: generateMemedImage())
   }
    
    
@IBAction func share(_ sender:Any) {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityView, animated:true, completion:nil)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
         if textFieldB.isEditing == true {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
            view.frame.origin.y =  0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldT.resignFirstResponder()
        textFieldB.resignFirstResponder()
        return true
    }
    
//    @IBAction func pickAnImageFromCamera(_ sender: Any) {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        present(imagePicker, animated: true, completion: nil)
//    }

}


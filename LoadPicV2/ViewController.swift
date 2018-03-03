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
    @IBOutlet weak var cameraButton: UIButton!
    
    
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
        cameraButton.isEnabled = isCameraAccesible()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        self.showImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        self.showImagePicker(sourceType: .camera)
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
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
        
        activityView.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed || error == nil {
                self.saveMeme()
            }
        }
        
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
    
    private func isCameraAccesible() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
}


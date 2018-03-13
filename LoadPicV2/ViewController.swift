//
//  ViewController.swift
//  LoadPicV2
//
//  Created by Rick Mc on 1/27/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var textFieldT : UITextField!
    @IBOutlet weak var textFieldB : UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    struct Meme {
        
        var topTextField: String?
        var bottomTextField: String?
        var originalImage: UIImage?
        let memedImage: UIImage!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(textfield: textFieldT, withText: "TOP")
        configure(textfield: textFieldB, withText: "BOTTOM")
        cameraButton.isEnabled = isCameraAccesible()

    }
    
    func configure(textfield: UITextField, withText text: String) {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName: -3.0 ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.backgroundColor = .clear
        textfield.textColor = .white
        textfield.textAlignment = .center
        textfield.delegate = self
        textfield.text = text
        textfield.borderStyle = .none
  
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
    
    func generateMemedImage() -> UIImage? {
        
        let imageSize = AVMakeRect(aspectRatio: self.imagePickView.image!.size, insideRect: self.imagePickView.bounds).size
        
        let image = self.imagePickView.image!
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        
        let topTextPosition = CGPoint(x: 0, y: 15) // you have to decide what is the best position. This is just an example
        
        let bottomTextPosition = CGPoint(x: 0, y: 325) // you have to decide what is the best position. This is just an example
        
        let topRect = CGRect(origin: topTextPosition, size: imageSize)
        self.textFieldT.text!.draw(in: topRect)
        
        let bottomRect = CGRect(origin: bottomTextPosition, size: imageSize)
        self.textFieldB.text!.draw(in: bottomRect)
        
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
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


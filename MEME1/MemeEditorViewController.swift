//
//  ViewController.swift
//  MEME1
//
//  Created by Remah on 11/20/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var album: UIBarButtonItem!

    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    
   
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var pickerImageView: UIImageView!
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func configure(textField :UITextField, withText text: String){
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
      
        
        let memeTextAttributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue) : UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0 ]
        
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
        
        
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            // show test
            print("Show BT")
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            // hide test
            print("Hide TB")
            view.frame.origin.y = 0.0
        }
        
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self    //to show the selected image
        imagePicker.sourceType = .photoLibrary
        self.present( imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present( imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            pickerImageView.image = imagePicker
        } else {
            print ("Can't pick the image")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated:true, completion:nil)
    }

    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }

    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, completed, items, error) in
        
            }
    
        present( controller, animated: true, completion: nil)
    }
    
  
    
    @IBAction func cancel(_ sender: Any) {
        pickerImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
    
}
    


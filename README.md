<h1 align="center"> MemeMe v1 </h1> <br>

<h4 align="center">Image editng app allowing you to add text for a meme.</h4> <br>
 

## Intro

This project allows you to select an image from your album, add text to it and save it as a meme. 

<p align="center">
  <img alt="onthemap" title="onthemap" src="screenshots/mmv1.gif" width=300>
</p>
<br>

## Functions 

* Select iamge for adding text to and then save as meme.
* UI customization for text placement.  
* Also allow cameera to take picture for meme.
<br>

## Loading image data from device library

This included using images from the device's storage, so it was interesting implementing methods for pulling up the device's album.

``` swift
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        self.showImagePicker(sourceType: .photoLibrary)
        
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
```
<br>

## Article Tips

Some good articles for tips : <br>
* <a href="https://www.yudiz.com/working-with-unwind-segues-in-swift" target="_blank">Working with Segue unwinds in Swift</a><br>
* <a href="https://blog.supereasyapps.com/30-auto-layout-best-practices/#layout-ui-for-one-iphone" target="_blank">30 Auto Layout Best Practices</a>

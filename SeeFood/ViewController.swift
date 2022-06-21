//
//  ViewController.swift
//  SeeFood
//
//  Created by Kenneth Sidibe on 2022-06-20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraImageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Failed to convert image to CiImage")
            }
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true)
        
    }
    
    func detect(image: CIImage) {
        
//        We first create our model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to create coreML model")
        }
        
//        We create our request to the model ti classify the data
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to get results from VSObservation")
            }
            
            if let firstResult = results.first {
                
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
//        We set the data to be classified here
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("Error while performing the handler request \(error)")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


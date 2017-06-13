//
//  ViewController.swift
//  BrideNotBride
//
//  Created by Mac Bellingrath on 6/13/17.
//  Copyright © 2017 WeddingWire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// provides prediction results
    fileprivate let service = PredictionService()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    @IBAction func pickTapped(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true) {
            self.resetLabel()
        }
    }

    @IBAction func reset(_ sender: Any) {
        resetLabel()
        resetImageView()
    }

    fileprivate func resetLabel() {
        label.text = "choose image to see prediction"
        label.backgroundColor = .clear
    }

    fileprivate func resetImageView() {
        imageView.image = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabel()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = getImage(fromPicker: picker, info: info) else {
            return
        }

        imageView.image = image

        let prediction = service.predict(image: image)?.first
        let possiblePrediction = (prediction?.possiblePrediction ?? "").lowercased()
        let prob = prediction?.probability ?? 0

        updateLabelWithLemonPrediction(possiblePrediction, prob)
        picker.dismiss(animated: true)
    }

    fileprivate func getImage(fromPicker picker: UIImagePickerController, info: [String: Any]) -> UIImage? {
        return info[UIImagePickerControllerOriginalImage] as? UIImage ?? info[UIImagePickerControllerEditedImage] as? UIImage
    }

    fileprivate func updateLabelWithLemonPrediction(_ possiblePrediction: String, _ prob: Double) {
        let isLemon = possiblePrediction == "lemon" || possiblePrediction.contains("lemon")
        let text = isLemon ? "Lemon!" : "Not Lemon!"
        let color = isLemon ? UIColor.green : UIColor.red
        label.backgroundColor = color
        label.text = text
    }
}


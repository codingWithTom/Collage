//
//  CanvasViewModel.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-09-25.
//

import Foundation
import UIKit
import PhotosUI

final class CanvasViewModel: ObservableObject {
  @Published var images: [UIImage] = []
  
  var canTakePictures: Bool {
    UIImagePickerController.isSourceTypeAvailable(.camera)
  }
  
  func handleAddedImage(_ addedImage: UIImage) {
    DispatchQueue.main.async {
      self.images.append(addedImage)
    }
  }
  
  func handleResults(_ results: [PHPickerResult]) {
    for result in results {
      result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
        guard let image = imageObject as? UIImage else { return }
        DispatchQueue.main.async { [weak self] in
          self?.images.append(image)
        }
      }
    }
  }
}

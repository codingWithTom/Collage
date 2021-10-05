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
  @Published var items: [CanvasView.MediaItem] = []
  
  var canTakePictures: Bool {
    UIImagePickerController.isSourceTypeAvailable(.camera)
  }
  
  func handleAddedImage(_ addedImage: UIImage) {
    DispatchQueue.main.async {
      self.items.append(.photo(addedImage))
    }
  }
  
  func handleResults(_ results: [PHPickerResult]) {
    for result in results {
      if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
        loadImage(from: result)
      } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
        loadVideoURL(from: result)
      }
    }
  }
}

private extension CanvasViewModel {
  func loadImage(from result: PHPickerResult) {
    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
      guard let image = imageObject as? UIImage else { return }
      DispatchQueue.main.async { [weak self] in
        self?.items.append(.photo(image))
      }
    }
  }
  
  func loadVideoURL(from result: PHPickerResult) {
    result.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] videoURL, error in
      guard let url = videoURL as? URL else { return }
      DispatchQueue.main.async { [weak self] in
        self?.items.append(.video(url))
      }
    }
  }
}

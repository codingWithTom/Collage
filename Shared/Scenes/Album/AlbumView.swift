//
//  AlbumView.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-10-09.
//

import SwiftUI
import AVKit
import PhotosUI

struct AlbumView: UIViewControllerRepresentable {
  let views: [CanvasView.MediaItem]
  
  func makeCoordinator() -> AlbumViewCoordinator {
    AlbumViewCoordinator()
  }
  
  func makeUIViewController(context: Context) -> AlbumViewController {
    let controller = AlbumViewController()
    controller.views = views.map(context.coordinator.processItem)
    print("Number of views: \(views.count)")
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AlbumViewController, context: Context) {
  }
}

final class AlbumViewCoordinator {
  private var avPlayerControllers: [AVPlayerViewController] = []
  
  func processItem(_ mediaItem: CanvasView.MediaItem) -> UIView {
    switch mediaItem {
    case .photo(let image):
      let imageView = UIImageView(image: image)
      imageView.frame = CGRect(origin: .zero,
                               size: CGSize(width: 175, height: 175)
      )
      return imageView
    case .video(let url):
      let controller = AVPlayerViewController()
      controller.player = AVPlayer(url: url)
      avPlayerControllers.append(controller)
      controller.view.frame = CGRect(origin: .zero,
                                     size: CGSize(width: 175, height: 175)
      )
      return controller.view
    case .livePhoto(let livePhoto):
      let livePhotoView = PHLivePhotoView()
      livePhotoView.livePhoto = livePhoto
      livePhotoView.startPlayback(with: .hint)
      livePhotoView.frame = CGRect(origin: .zero,
                                   size: CGSize(width: 175, height: 175)
      )
      return livePhotoView
    }
  }
}

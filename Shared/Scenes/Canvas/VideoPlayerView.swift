//
//  VideoPlayerView.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-10-04.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    controller.player = AVPlayer(url: url)
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}

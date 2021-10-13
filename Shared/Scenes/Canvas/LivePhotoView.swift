//
//  LivePhotoView.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-10-06.
//

import SwiftUI
import PhotosUI

struct LivePhotoView: UIViewRepresentable {
  let photo: PHLivePhoto
  
  func makeUIView(context: Context) -> PHLivePhotoView {
    let view = PHLivePhotoView()
    view.livePhoto = photo
    view.startPlayback(with: .hint)
    return view
  }
  
  func updateUIView(_ uiView: PHLivePhotoView, context: Context) { }
}

//
//  CanvasView.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-09-25.
//

import SwiftUI
import PhotosUI

struct CanvasView: View {
  enum MediaItem {
    case photo(UIImage)
    case video(URL)
  }
  
  @StateObject private var viewModel = CanvasViewModel()
  @State private var isShowingImagePicker = false
  @State private var isShowingCameraPicker = false
  @State private var isShowingCameraVideoPicker = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(175), spacing: 10), count: 2)) {
            ForEach(viewModel.items.indices, id: \.self) { index in
              let item = viewModel.items[index]
              if case .photo(let image) = item {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFill()
              } else if case .video(let url) = item {
                VideoPlayerView(url: url)
                  .frame(width: 175, height: 175)
              }
            }
          }
      }
      .navigationTitle("Canvas")
      .navigationBarItems(
        trailing:
          trailingButtons
      )
    }
    .sheet(isPresented: $isShowingImagePicker) {
      PhotosPickerView(isPresented: $isShowingImagePicker) {
        viewModel.handleResults($0) 
      }
    }
    .sheet(isPresented: $isShowingCameraPicker) {
      CameraPickerView(
        isPresented: $isShowingCameraPicker,
        onOutput: .picture({ viewModel.handleAddedImage($0) })
      )
    }
    .sheet(isPresented: $isShowingCameraVideoPicker) {
      CameraPickerView(
        isPresented: $isShowingCameraVideoPicker,
        onOutput: .video({ viewModel.handleAddedVideo($0) }))
    }
  }
  
  private var trailingButtons: some View {
    HStack {
      if viewModel.isCameraAvailable {
        Button(action: { isShowingCameraPicker.toggle() }) {
          Image(systemName: "camera")
        }
        Button(action: { isShowingCameraVideoPicker.toggle() }) {
          Image(systemName: "film")
        }
      }
      Button(action: { isShowingImagePicker.toggle() }) {
        Image(systemName: "plus.circle")
      }
    }
  }
}

struct CanvasView_Previews: PreviewProvider {
  static var previews: some View {
    CanvasView()
  }
}

//
//  CanvasView.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-09-25.
//

import SwiftUI
import PhotosUI

struct CanvasView: View {
  
  @StateObject private var viewModel = CanvasViewModel()
  @State private var isShowingImagePicker = false
  @State private var isShowingCameraPicker = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(175), spacing: 10), count: 2)) {
            ForEach(viewModel.images.indices, id: \.self) {
              Image(uiImage: viewModel.images[$0])
                .resizable()
                .scaledToFill()
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
      CameraPickerView(isPresented: $isShowingCameraPicker) {
        viewModel.handleAddedImage($0)
      }
    }
  }
  
  private var trailingButtons: some View {
    HStack {
      if viewModel.canTakePictures {
        Button(action: { isShowingCameraPicker.toggle() }) {
          Image(systemName: "camera")
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

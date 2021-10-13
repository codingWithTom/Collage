//
//  CollageApp.swift
//  Shared
//
//  Created by Tomas Trujillo on 2021-09-25.
//

import SwiftUI

@main
struct CollageApp: App {
  var body: some Scene {
    WindowGroup {
      TempView()
    }
  }
}

final class TempViewModel: ObservableObject {
  @Published var items: [CanvasView.MediaItem] = []
}

struct TempView: View {
  @State private var isPresentingCanvas: Bool = false
  @State private var isPresentingAlbum: Bool = false
  @StateObject private var viewModel = TempViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      Button(action: { isPresentingCanvas.toggle() }) {
        Text("Canvas")
      }
      Spacer()
      Button(action: { isPresentingAlbum.toggle() }) {
        Text("Album")
      }
      Spacer()
    }
    .sheet(isPresented: $isPresentingCanvas) {
      CanvasView(mediaItems: $viewModel.items)
    }
    .sheet(isPresented: $isPresentingAlbum) {
      AlbumView(views: viewModel.items)
    }
  }
}

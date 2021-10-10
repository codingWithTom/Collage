//
//  AlbumPageViewController.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-10-10.
//

import UIKit

class AlbumPageViewController: UIViewController {
  private lazy var animator: UIDynamicAnimator = {
    let animator = UIDynamicAnimator(referenceView: self.view)
    return animator
  }()
  
  var views: [UIView] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func animateItems() {
    setup()
  }
  
}

private extension AlbumPageViewController {
  func setup() {
    let offScreenOrigin = CGPoint(x: -view.bounds.width, y: view.bounds.height / 2)
    views.enumerated().forEach { index, view in
      self.view.addSubview(view)
      view.frame = CGRect(origin: offScreenOrigin, size: view.bounds.size)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 * Double(index)) { [weak self] in
        self?.snapItem(view, index: index)
      }
    }
  }
  
  func snapItem(_ item: UIDynamicItem, index: Int) {
    let width = view.bounds.width
    let height = view.bounds.height
    let xPosition = width / 4 + (width / 2 * CGFloat(index % 2))
    let yPosition = height / 6 + (height / 3 * CGFloat(Int(index / 2)))
    let snapPoint = CGPoint(x: xPosition, y: yPosition)
    let snapBehavior = UISnapBehavior(item: item, snapTo: snapPoint)
    animator.addBehavior(snapBehavior)
  }
}

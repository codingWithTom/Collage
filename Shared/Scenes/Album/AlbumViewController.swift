//
//  AlbumViewController.swift
//  Collage (iOS)
//
//  Created by Tomas Trujillo on 2021-10-09.
//

import UIKit

class AlbumViewController: UIViewController {
  private lazy var animator: UIDynamicAnimator = {
    let animator = UIDynamicAnimator(referenceView: self.view)
    return animator
  }()
  var views: [UIView] = []
  var pages: [AlbumPageViewController] = []
  private let itemsPerPage = 6
  private var currentindex = 0 {
    didSet {
      guard pages.count > 1 else { return }
      previousArrowView.isHidden = currentindex == 0
      nextArrowView.isHidden = currentindex == pages.count - 1
    }
  }
  private let arrowsSize: CGSize = CGSize(width: 75, height: 75)
  private var nextArrowOrigin: CGPoint {
    CGPoint(x: view.bounds.width - arrowsSize.width, y: view.bounds.height / 2 - arrowsSize.height / 2)
  }
  private lazy var nextArrowView: UIImageView = {
    let imageview = UIImageView(image: UIImage(systemName: "arrowshape.turn.up.left.2.fill"))
    imageview.tintColor = .orange.withAlphaComponent(0.75)
    imageview.frame = CGRect(
      origin: nextArrowOrigin,
      size: arrowsSize
    )
    imageview.isUserInteractionEnabled = true
    return imageview
  }()
  private var previousArrowOrigin: CGPoint {
    CGPoint(x: 0.0, y: view.bounds.height / 2 - arrowsSize.height / 2)
  }
  private lazy var previousArrowView: UIImageView = {
    let imageview = UIImageView(image: UIImage(systemName: "arrowshape.bounce.right.fill"))
    imageview.tintColor = .yellow.withAlphaComponent(0.75)
    imageview.frame = CGRect(
      origin: previousArrowOrigin,
      size: arrowsSize
    )
    imageview.isUserInteractionEnabled = true
    return imageview
  }()
  private var nextArrowOffset: CGPoint = .zero
  private var previousArrowOffset: CGPoint = .zero
  private var nextArrowSnapBehavior: UISnapBehavior?
  private var previousArrowSnapBehavior: UISnapBehavior?
  private var minimumRequiredOffsetToChangePage: CGFloat {
    view.bounds.width * 0.6
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setup()
  }
}

private extension AlbumViewController {
  func setup() {
    setPages()
    addArrows()
    currentindex = 0
    guard let firstPage = self.pages.first else { return }
    firstPage.view.frame = self.view.frame
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      firstPage.animateItems()
    }
  }
  
  func addArrows() {
    guard pages.count > 1 else { return }
    view.addSubview(nextArrowView)
    view.addSubview(previousArrowView)
    addGesturesToArrows()
  }
  
  func setPages() {
    var items = views
    while(!items.isEmpty) {
      let group = items.prefix(itemsPerPage)
      items.removeFirst(group.count)
      createPageWithGroup(Array(group))
    }
  }
  
  func createPageWithGroup(_ group: [UIView]) {
    let controller = AlbumPageViewController()
    controller.views = group
    var outOfBoundsFrame = view.frame
    outOfBoundsFrame.origin = CGPoint(x: view.bounds.width, y: 0.0)
    controller.view.frame = outOfBoundsFrame
    pages.append(controller)
    view.addSubview(controller.view)
    controller.didMove(toParent: self)
  }
  
  func presentNewPage(isGoingBack: Bool) {
    let oldPage = pages[currentindex + (isGoingBack ? 1 : -1)]
    let newPage = pages[currentindex]
    let viewFrame = view.frame
    UIView.animate(withDuration: 0.5) {
      var outOfBoundsFrame = viewFrame
      outOfBoundsFrame.origin = CGPoint(x: viewFrame.width, y: 0.0)
      oldPage.view.frame = outOfBoundsFrame
      newPage.view.frame = viewFrame
    } completion: { _ in
      newPage.animateItems()
    }
  }
  
  func addGesturesToArrows() {
    let previousArrowPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanPreviousArrow))
    previousArrowView.addGestureRecognizer(previousArrowPanGesture)
    let nextArrowPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanNextArrow))
    nextArrowView.addGestureRecognizer(nextArrowPanGesture)
  }
  
  @objc
  func didPanPreviousArrow(_ gesture: UIPanGestureRecognizer) {
    let anchorPoint = gesture.location(in: view)
    let center = previousArrowView.center
    switch gesture.state {
    case .began:
      if let snapBehavior = previousArrowSnapBehavior {
        previousArrowSnapBehavior = nil
        animator.removeBehavior(snapBehavior)
      }
      previousArrowOffset = CGPoint(x: anchorPoint.x - center.x, y: 0.0)
    case .ended:
      let newCenter = CGPoint(x: anchorPoint.x + previousArrowOffset.x, y: center.y)
      if newCenter.x > minimumRequiredOffsetToChangePage {
        moveBackOnePage()
      }
      snapBackPreviousArrow()
    default:
      let newCenter = CGPoint(x: anchorPoint.x + previousArrowOffset.x, y: center.y)
      previousArrowView.center = newCenter
    }
  }
  
  @objc
  func didPanNextArrow(_ gesture: UIPanGestureRecognizer) {
    let anchorPoint = gesture.location(in: view)
    let center = nextArrowView.center
    switch gesture.state {
    case .began:
      if let snapBehavior = nextArrowSnapBehavior {
        nextArrowSnapBehavior = nil
        animator.removeBehavior(snapBehavior)
      }
      nextArrowOffset = CGPoint(x: anchorPoint.x - center.x, y: 0.0)
    case .ended:
      let newCenter = CGPoint(x: anchorPoint.x + nextArrowOffset.x, y: center.y)
      if newCenter.x < view.bounds.width - minimumRequiredOffsetToChangePage {
        moveForwardOnePage()
      }
      snapBackNextArrow()
    default:
      let newCenter = CGPoint(x: anchorPoint.x + nextArrowOffset.x, y: center.y)
      nextArrowView.center = newCenter
    }
  }
  
  func moveBackOnePage() {
    currentindex -= 1
    presentNewPage(isGoingBack: true)
  }
  
  func moveForwardOnePage() {
    currentindex += 1
    presentNewPage(isGoingBack: false)
  }
  
  func snapBackPreviousArrow() {
    let snapPoint = CGPoint(x: previousArrowOrigin.x + arrowsSize.width / 2,
                            y: previousArrowOrigin.y + arrowsSize.height / 2)
    let snapBehavior = UISnapBehavior(item: previousArrowView, snapTo: snapPoint)
    previousArrowSnapBehavior = snapBehavior
    animator.addBehavior(snapBehavior)
  }
  
  func snapBackNextArrow() {
    let snapPoint = CGPoint(x: nextArrowOrigin.x + arrowsSize.width / 2,
                            y: nextArrowOrigin.y + arrowsSize.height / 2)
    let snapBehavior = UISnapBehavior(item: nextArrowView, snapTo: snapPoint)
    nextArrowSnapBehavior = snapBehavior
    animator.addBehavior(snapBehavior)
  }
}

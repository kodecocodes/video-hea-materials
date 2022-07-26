/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CareKit
import CareKitUI
import ResearchKit
import CareKitStore


final class OverviewViewController: OCKListViewController {
  let storeManager: OCKSynchronizedStoreManager

  init(storeManager: OCKSynchronizedStoreManager) {
    self.storeManager = storeManager
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true

  }
  
  func makeChart1() {
    // A spacer view.
    appendView(UIView(), animated: false)

    // Create Muscle Series


    // Create Headache Series

      
    // Create Bar Chart
    
    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart2() {
    // A spacer view.
    appendView(UIView(), animated: false)

    // Create Tiredness Series


    // Create Bar Chart

    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart3() {
    // A spacer view.
    appendView(UIView(), animated: false)

    // Create Fever Series


    // Create Line Chart

    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart4() {
    // A spacer view.
    appendView(UIView(), animated: false)
    // Create Range Series

    // Create Scatter Chart

    // A spacer view.
    appendView(UIView(), animated: false)
  }
}

extension OCKAnyEvent {
  func answer(kind: String) -> Double {
    let values = outcome?.values ?? []
    let match = values.first { item in
      item.kind == kind
    }
    return match?.doubleValue ?? 0
  }
}

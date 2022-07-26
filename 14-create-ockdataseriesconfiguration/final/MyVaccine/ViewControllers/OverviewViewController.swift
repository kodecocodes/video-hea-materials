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
    let muscleSeries = OCKDataSeriesConfiguration(
      taskID: TaskModel.checkIn.rawValue,
      legendTitle: "Muscle Pain (1-10)",
      gradientStartColor: UIColor(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
      gradientEndColor: UIColor(red: 1, green: 0.462745098, blue: 0.368627451, alpha: 1),
      markerSize: 10,
      eventAggregator: .custom { events in
        events
          .first?
          .answer(kind: IdentifierModel.checkinMuscle.rawValue)
          ?? 0
      }
    )

    // Create Headache Series
    let  headacheSeries = OCKDataSeriesConfiguration(
      taskID: TaskModel.checkIn.rawValue,
      legendTitle: "Headache (1-10)",
      gradientStartColor: UIColor(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
      gradientEndColor: UIColor(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
      markerSize: 10,
      eventAggregator: .custom { events in
        events
          .first?
          .answer(kind: IdentifierModel.checkinHeadache.rawValue)
          ?? 0
      }
    )
      
    // Create Bar Chart
    
    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart2() {
    // A spacer view.
    appendView(UIView(), animated: false)

    // Create Tiredness Series
    let tirednessSeries = OCKDataSeriesConfiguration(
      taskID: TaskModel.checkIn.rawValue,
      legendTitle: "Tiredness (0-10)",
      gradientStartColor: UIColor(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
      gradientEndColor: UIColor(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
      markerSize: 10,
      eventAggregator: .custom { events in
        events
          .first?
          .answer(kind: IdentifierModel.checkinTiredness.rawValue)
          ?? 0
      }
    )

    // Create Bar Chart

    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart3() {
    // A spacer view.
    appendView(UIView(), animated: false)

    // Create Fever Series
    let feverSeries = OCKDataSeriesConfiguration(
      taskID: TaskModel.checkIn.rawValue,
      legendTitle: "Temprature (35°C-42°C)",
      gradientStartColor: UIColor(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
      gradientEndColor: UIColor(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
      markerSize: 2,
      eventAggregator: .custom { events in
        events
          .first?
          .answer(kind: IdentifierModel.checkinFever.rawValue)
          ?? 0
      }
    )

    // Create Line Chart

    // A spacer view.
    appendView(UIView(), animated: false)
  }

  func makeChart4() {
    // A spacer view.
    appendView(UIView(), animated: false)
    // Create Range Series
    let rangeSeries = OCKDataSeriesConfiguration(
      taskID: TaskModel.motionCheck.rawValue,
      legendTitle: "Range of Motion (degrees)",
      gradientStartColor: UIColor(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
      gradientEndColor: UIColor(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
      markerSize: 3,
      eventAggregator: .custom { events in
        events
          .first?
          .answer(kind: #keyPath(ORKRangeOfMotionResult.range))
          ?? 0
      }
    )

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

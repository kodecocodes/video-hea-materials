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

import CareKitStore
import ResearchKit
import HealthKit

enum SurveyViewModel {
  //  Extract outcome
  static func checkInSurveyOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
  guard
    let response = result.results?
      .compactMap({ $0 as? ORKStepResult })
      .first(where: { $0.identifier == IdentifierModel.checkinForm.rawValue }),
    let scaleResults = response.results?
      .compactMap({ $0 as? ORKScaleQuestionResult }),
    let musclePainAnswer = scaleResults
      .first(where: { $0.identifier == IdentifierModel.checkinMuscle.rawValue })?
      .scaleAnswer,
    let headacheAnswer = scaleResults
      .first(where: { $0.identifier == IdentifierModel.checkinHeadache.rawValue })?
      .scaleAnswer,
    let tirednessAnswer = scaleResults
      .first(where: { $0.identifier == IdentifierModel.checkinTiredness.rawValue })?
      .scaleAnswer,
    let feverAnswer = scaleResults
      .first(where: { $0.identifier == IdentifierModel.checkinFever.rawValue })?
      .scaleAnswer,
    let nauseaAnswer = scaleResults
      .first(where: { $0.identifier == IdentifierModel.checkinNausea.rawValue })?
      .scaleAnswer
  else {
    assertionFailure("Failed to extract answers from check in survey!")
    return nil
  }

    var musclePainValue = OCKOutcomeValue(Double(truncating: musclePainAnswer))
    musclePainValue.kind = IdentifierModel.checkinMuscle.rawValue

    var headacheValue = OCKOutcomeValue(Double(truncating: headacheAnswer))
    headacheValue.kind = IdentifierModel.checkinHeadache.rawValue

    var tirednessValue = OCKOutcomeValue(Double(truncating: tirednessAnswer))
    tirednessValue.kind = IdentifierModel.checkinTiredness.rawValue

    var feverValue = OCKOutcomeValue(Double(truncating: feverAnswer))
    feverValue.kind = IdentifierModel.checkinFever.rawValue

    var nauseaValue = OCKOutcomeValue(Double(truncating: nauseaAnswer))
    nauseaValue.kind = IdentifierModel.checkinNausea.rawValue

    // Call HealthKit function
    SurveyViewModel.addBodyTemperatureToHealthKit(temp: feverValue.doubleValue, date: result.endDate)
  
    return [musclePainValue, headacheValue, tirednessValue, feverValue, nauseaValue]
  }

  static func rangeOfMotionSurveyOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
    guard
      let motionResult = result.results?
        .compactMap({ $0 as? ORKStepResult })
        .compactMap({ $0.results })
        .flatMap({ $0 })
        .compactMap({ $0 as? ORKRangeOfMotionResult })
        .first else {
      assertionFailure("Failed to parse range of motion result")
      return nil
    }
    var range = OCKOutcomeValue(motionResult.range)
    range.kind = #keyPath(ORKRangeOfMotionResult.range)
    return [range]
  }
  
  // Save data into the HealthKit
  static func addBodyTemperatureToHealthKit(temp: Double?, date: Date) {
    guard let quantityType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature) else { return }
    guard let categoryType = HKObjectType.categoryType(forIdentifier: .fever) else { return }
    guard let temp = temp else { return }

    let quanitytUnit = HKUnit(from: "degC" )
    let quantityAmount = HKQuantity(unit: quanitytUnit, doubleValue: temp)
    let tempSample = HKQuantitySample(type: quantityType, quantity: quantityAmount, start: date, end: date)
    let feverSample = HKCategorySample(type: categoryType, value: Int((temp - 35 ) / 7.0 * 5), start: date, end: date)
    if HKHealthStore.isHealthDataAvailable() {
      let store = HKHealthStore()
      store.save([feverSample, tempSample]) { _, error in
        if error != nil {
          Logger.survey.error("Failed to write data to HK")
        }
      }
    }
  }

}

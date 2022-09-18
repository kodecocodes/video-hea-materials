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

enum SurveyManager {
  //  Prepare Onboarding Survey - ResearchTask
  private static var welcomeInstructionStep: ORKInstructionStep {
    let welcomeInstructionStep = ORKInstructionStep(
      identifier: IdentifierModel.onboardingWelcome.rawValue
    )
    welcomeInstructionStep.title = "Welcome!"
    welcomeInstructionStep.detailText =
      "Thank you for attending to this course. Tap Next to learn more before start using."
    welcomeInstructionStep.image = UIImage(named: "welcome-image")
    welcomeInstructionStep.imageContentMode = .scaleAspectFill
    return welcomeInstructionStep
  }
  private static var overviewInstructionStep: ORKInstructionStep {
    let overviewInstructionStep = ORKInstructionStep(
      identifier: IdentifierModel.onboardingOverview.rawValue
    )
    overviewInstructionStep.title = "Before You Start"
    overviewInstructionStep.iconImage = UIImage(systemName: "checkmark.seal.fill")
    let heartBodyItem = ORKBodyItem(
      text: "The app will ask you to share some of your health data.",
      detailText: nil,
      image: UIImage(systemName: "heart.fill"),
      learnMoreItem: nil,
      bodyItemStyle: .image
    )
    let completeTasksBodyItem = ORKBodyItem(
      text: "You will be asked to complete various tasks over the duration of using the app.",
      detailText: nil,
      image: UIImage(systemName: "checkmark.circle.fill"),
      learnMoreItem: nil,
      bodyItemStyle: .image
    )
    let signatureBodyItem = ORKBodyItem(
      text: "Before joining, we will ask you to sign an informed consent document.",
      detailText: nil,
      image: UIImage(systemName: "signature"),
      learnMoreItem: nil,
      bodyItemStyle: .image
    )
    let secureDataBodyItem = ORKBodyItem(
      text: "Your data is kept private and secure on your iPhone.",
      detailText: nil,
      image: UIImage(systemName: "lock.fill"),
      learnMoreItem: nil,
      bodyItemStyle: .image
    )
    overviewInstructionStep.bodyItems = [
      heartBodyItem,
      completeTasksBodyItem,
      signatureBodyItem,
      secureDataBodyItem
    ]
    return overviewInstructionStep
  }
  private static var webViewStep: ORKWebViewStep {
    let file = Bundle.main.path(forResource: "consent", ofType: "html") ?? ""
    let html = try? String(contentsOfFile: file, encoding: String.Encoding.utf8)
    let consentHTML = html ?? ""
    let webViewStep = ORKWebViewStep(
      identifier: IdentifierModel.onboardingSignatureCapture.rawValue,
      html: consentHTML
    )
    webViewStep.showSignatureAfterContent = true
    return webViewStep
  }
  private static var requestPermissionsStep: ORKRequestPermissionsStep {
    var healthKitTypesToWrite: Set<HKSampleType> = []
    if
      let fever = HKObjectType.categoryType(forIdentifier: .fever),
      let bodyTemperature = HKObjectType.quantityType(forIdentifier: .bodyTemperature) {
      healthKitTypesToWrite.insert(fever)
      healthKitTypesToWrite.insert(bodyTemperature)
    }

    var healthKitTypesToRead: Set<HKObjectType> = []

    if let fever = HKObjectType.categoryType(forIdentifier: .fever),
      let bodyTemperature = HKObjectType.quantityType(forIdentifier: .bodyTemperature) {
      healthKitTypesToRead.insert(fever)
      healthKitTypesToRead.insert(bodyTemperature)
    }
    let healthKitPermissionType = ORKHealthKitPermissionType(
      sampleTypesToWrite: healthKitTypesToWrite,
      objectTypesToRead: healthKitTypesToRead
    )
    let notificationsPermissionType = ORKNotificationPermissionType(
      authorizationOptions: [.alert, .badge, .sound]
    )
    let motionPermissionType = ORKMotionActivityPermissionType()
    let requestPermissionsStep = ORKRequestPermissionsStep(
      identifier: IdentifierModel.onboardingRequestPermissions.rawValue,
      permissionTypes: [
        healthKitPermissionType,
        notificationsPermissionType,
        motionPermissionType
      ]
    )
    requestPermissionsStep.title = "Health Data Request"
    requestPermissionsStep.text =
      "Please review the health data types below and enable sharing to contribute to the app."

    return requestPermissionsStep
  }
  private static var completionStep: ORKCompletionStep {
    let completionStep = ORKCompletionStep(identifier: IdentifierModel.onboardingCompletion.rawValue)
    completionStep.title = "Task Complete"
    completionStep.text = "Thank you for starting this corse!"
    return completionStep
  }
  static func onboardingSurvey() -> ORKTask {
    let surveyTask = ORKOrderedTask(
      identifier: IdentifierModel.onboardingStep.rawValue,
      steps: [
        welcomeInstructionStep,
        overviewInstructionStep,
        webViewStep,
        requestPermissionsStep,
        completionStep
      ]
    )
    return surveyTask
  }
}

extension SurveyManager {
  //  Prepare Vaccination Survey - ResearchTask
}

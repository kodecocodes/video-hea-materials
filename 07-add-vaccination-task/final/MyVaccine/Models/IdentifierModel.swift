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

import Foundation

enum IdentifierModel: String {
  case onboardingWelcome = "onboarding.welcome"
  case onboardingOverview = "onboarding.overview"
  case onboardingSignatureCapture = "onboarding.signatureCapture"
  case onboardingRequestPermissions = "onboarding.requestPermissions"
  case onboardingCompletion = "onboarding.completion"
  case onboardingStep = "onboarding.step"

  case vaccinationWelcome = "vaccination.welcome"
  case vaccinationBirthday = "vaccination.birthday"
  case vaccinationType = "vaccination.type"
  case vaccinationDate = "vaccination.date"
  case vaccinationCompletion = "vaccination.completion"
  case vaccinationStep = "vaccination.step"

  case checkinMuscle = "checkin.muscle"
  case checkinHeadache = "checkin.headache"
  case checkinTiredness = "checkin.tiredness"
  case checkinFever = "checkin.fever"
  case checkinNausea = "checkin.nausea"
  case checkinForm = "checkin.form"
  case checkinStep = "checkin.step"

  case motionCompletion = "motion.completion"
  case motionStep = "motion.step"
}

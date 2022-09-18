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

import CareKit
import CareKitStore
import UIKit
import os.log

enum TaskManager {
  // Make Onboarding - CareKitTask
  static func makeOnboarding() -> OCKTask {
    let onboardingSchedule = OCKSchedule.dailyAtTime(
      hour: 0,
      minutes: 0,
      start: Date(),
      end: nil,
      text: "Due date is today!",
      duration: .allDay)
    var onboardingTask = OCKTask(
      id: TaskModel.onboarding.rawValue,
      title: "Onboarding Task",
      carePlanUUID: nil,
      schedule: onboardingSchedule)
    onboardingTask.instructions = "You have to review this task to be able to get access to the app!"
    onboardingTask.impactsAdherence = false

    return onboardingTask
  }
  // Make Vaccination - CareKitTask
  static func makeVaccinationCheck() -> OCKTask {
    let schedule = OCKSchedule.dailyAtTime(
      hour: 0,
      minutes: 0,
      start: Date(),
      end: nil,
      text: nil,
      duration: .allDay)
    var task = OCKTask(
      id: TaskModel.vaccinationCheck.rawValue,
      title: "Vaccination Task",
      carePlanUUID: nil,
      schedule: schedule)
    task.instructions =
      "Please check your local health authorities for guidance and finds out when you are able to get vaccination."
    task.impactsAdherence = false
    return task
  }
  // Make CheckIn - CareKitTask
  static func makeCheckin() -> OCKTask {
    let schedule = OCKSchedule.dailyAtTime(
      hour: 8,
      minutes: 0,
      start: Date(),
      end: nil,
      text: nil
    )
    let task = OCKTask(
      id: TaskModel.checkIn.rawValue,
      title: "Check In",
      carePlanUUID: nil,
      schedule: schedule
    )
    return task
  }
}

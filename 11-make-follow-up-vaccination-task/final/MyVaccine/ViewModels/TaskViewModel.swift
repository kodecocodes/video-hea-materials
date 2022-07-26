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
import ResearchKit

enum TaskViewModel {
  static func prepareTasks(storeManager: OCKSynchronizedStoreManager, tasksList: [OCKTask]) {
    storeManager.store.addAnyTasks(tasksList, callbackQueue: .main) { result in
      switch result {
      case let .success(tasks):
        Logger.storeManager.info("Saved \(tasks.count) tasks")
      case let .failure(error):
        Logger.storeManager.warning("Failed to save tasks: \(error as NSError)")
      }
    }
  }

  static func makeTaskViewController(input: TaskModel?, date: Date, storeManager: OCKSynchronizedStoreManager, listViewController: OCKListViewController, delegate: OCKSurveyTaskViewControllerDelegate) {
    guard let input = input else { return }
    
    // Check the Date for future blocker
    let isFuture = Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending

    // Make Onboarding ViewController
    switch input {
    case .onboarding:
      TaskViewModel.checkIfInputTaskIsComplete(input: input, storeManager: storeManager) { isComplete in
        if !isComplete {
          let viewController = OCKSurveyTaskViewController(
            taskID: input.rawValue,
            eventQuery: OCKEventQuery(for: date),
            storeManager: storeManager,
            survey: SurveyManager.onboardingSurvey(),
            extractOutcome: { _ in [OCKOutcomeValue(Date())] })
          viewController.surveyDelegate = delegate
          // Block the future tasks
          viewController.view.isUserInteractionEnabled = !isFuture
          viewController.view.alpha = isFuture ? 0.4 : 1.0
          listViewController.appendViewController(viewController, animated: false)
        }
      }
      // Add SecondVaccinationCheck Case
    case .vaccinationCheck, .secondVaccinationCheck:
      TaskViewModel.checkIfInputTaskIsComplete(input: input, storeManager: storeManager) { isComplete in
        if !isComplete {
          let viewController = OCKSurveyTaskViewController(
            taskID: input.rawValue,
            eventQuery: OCKEventQuery(for: date),
            storeManager: storeManager,
            survey: SurveyManager.vaccinationSurvey(),
            // Extract Outcome
            extractOutcome: { result in
              if let survey = result.results?.first(where: { $0.identifier == "vaccination.date" }) as? ORKStepResult,
              let dateResult = survey.results?.first as? ORKDateQuestionResult,
              let answer = dateResult.dateAnswer {
                TaskViewModel.prepareTasks(
                  storeManager: storeManager,
                  tasksList: [
                    TaskManager.makeNextVaccination(date: answer)
                  ])
              }
              return [OCKOutcomeValue(Date())] })
          viewController.surveyDelegate = delegate
          // Block the future tasks
          viewController.view.isUserInteractionEnabled = !isFuture
          viewController.view.alpha = isFuture ? 0.4 : 1.0
          listViewController.appendViewController(viewController, animated: false)
        }
      }
    // Make CheckIn ViewController
    case .checkIn:
      let viewController = OCKSurveyTaskViewController(
        taskID: TaskModel.checkIn.rawValue,
        eventQuery: OCKEventQuery(for: date),
        storeManager: storeManager,
        survey: SurveyManager.checkInSurvey(),
        extractOutcome: { _ in return [OCKOutcomeValue(Date())] })
      viewController.surveyDelegate = delegate
      viewController.view.isUserInteractionEnabled = !isFuture
      viewController.view.alpha = isFuture ? 0.4 : 1.0
      listViewController.appendViewController(viewController, animated: false)
    }
  }
  static func checkIfInputTaskIsComplete(input: TaskModel, storeManager: OCKSynchronizedStoreManager, _ completion: @escaping (Bool) -> Void) {
    var query = OCKOutcomeQuery()
    query.taskIDs = [input.rawValue]
    storeManager.store.fetchAnyOutcomes(
      query: query,
      callbackQueue: .main) { result in
      switch result {
      case .failure:
        Logger.task.error("Failed to get onboarding!")
        completion(false)
      case let .success(outcomes):
        completion(!outcomes.isEmpty)
      }
    }
  }
  // Fetch tasks by date
  static func fetchTasks(on date: Date, storeManager: OCKSynchronizedStoreManager, completion: @escaping([OCKAnyTask]) -> Void) {
    var query = OCKTaskQuery(for: date)
    query.excludesTasksWithNoEvents = true

    storeManager.store.fetchAnyTasks(
      query: query,
      callbackQueue: .main) { result in
      switch result {
      case .failure:
        Logger.task.error("Failed to fetch tasks for date \(date)")
        completion([])
      case let .success(tasks):
        completion(tasks)
      }
    }
  }
}

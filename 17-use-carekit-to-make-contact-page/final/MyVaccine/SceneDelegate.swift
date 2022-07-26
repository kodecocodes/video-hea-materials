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

@UIApplicationMain
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
  lazy var storeManager = OCKSynchronizedStoreManager(
    wrapping: OCKStore(
      name: "com.raywenderlich.MyVaccine.carekitstore",
      type: .onDisk(protection: .none)
    )
  )

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Add CheckIn Task to the StoreManager
    let taskList = [TaskManager.makeOnboarding(),
                    TaskManager.makeVaccinationCheck(),
                    TaskManager.makeCheckin()]
    TaskViewModel.prepareTasks(storeManager: storeManager, tasksList: taskList)
    let planViewController = TaskViewController(storeManager: storeManager)
    planViewController.title = "My Vaccine"
    planViewController.tabBarItem = UITabBarItem(
      title: "Vaccine Plan",
      image: UIImage(systemName: "heart.text.square.fill"),
      tag: 0
    )

    let overviewViewController = OverviewViewController(storeManager: storeManager)
    overviewViewController.title = "Overview"
    overviewViewController.tabBarItem = UITabBarItem(
      title: "Overview",
      image: UIImage(systemName: "chart.bar.xaxis"),
      tag: 1
    )
    
    // Create Contact Page
    
    makeContacts()
    let contactViewController  = OCKListViewController()
    contactViewController.appendViewController(OCKDetailedContactViewController(contactID: "contact.emad", storeManager: storeManager), animated: false)
    contactViewController.title = "Contact"
    contactViewController.tabBarItem = UITabBarItem(
      title: "Contact",
      image: UIImage(systemName: "list.bullet"),
      tag: 1
    )

    let rootController = UITabBarController()
    let planTab = UINavigationController(rootViewController: planViewController)
    let overviewTab = UINavigationController(rootViewController: overviewViewController)
    // Create Contact Tab
    let contactTab = UINavigationController(rootViewController: contactViewController)
    // Add Contact Tab to the Tabbar
    rootController.setViewControllers([planTab, overviewTab, contactTab], animated: false)

    guard case let scene as UIWindowScene = scene else { return }
    window = UIWindow(windowScene: scene)
    window?.rootViewController = rootController
    window?.makeKeyAndVisible()
  }

  private func makeContacts() {
    var contact1 = OCKContact(id: "contact.emad", givenName: "Emad", familyName: "Ghorbaninia", carePlanUUID: nil)
    contact1.role = "Dr. Ghorbaninia is a family practice doctor with over 20 years of experience."
    let phoneNumbers1 = [OCKLabeledValue(label: "work", value: "+4531755093")]
    contact1.phoneNumbers = phoneNumbers1
    contact1.title = "Family Practice"
    contact1.messagingNumbers = phoneNumbers1
    contact1.emailAddresses = [OCKLabeledValue(label: "work", value: "emadgnia@icloud.com")]
    let address1 = OCKPostalAddress()
    address1.street = "C.F. Mollers"
    address1.city = "CPH"
    address1.state = "CPH"
    address1.postalCode = "2300"
    contact1.address = address1
    
    storeManager.store.addAnyContacts([contact1], callbackQueue: .main) { result in
      switch result {
      case .success(_):
        Logger.storeManager.info("Saved contacts")
      case let .failure(error):
        Logger.storeManager.warning("Failed to save tasks: \(error as NSError)")
      }
    }
  }

}

//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.09.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Properties

    var window: UIWindow?
    let database = DatabaseStack()

    // MARK: - Private Properties

    private let gcdService: MultithreadingFactory = GCDService()
    private let themeService = ThemeService()

    // MARK: - Public Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        LogService.shared.info(message: "Application moved from not running to inactive: \(#function)")

        createFiles()
        setupTheme()
        setupAuth()

        FirebaseApp.configure()

        ChannelService.shared.configure(with: database)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LogService.shared.info(message: "Application moved from inactive to active: \(#function)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        LogService.shared.info(message: "Application moved from active to inactive: \(#function)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LogService.shared.info(message: "Application moved from inactive to background: \(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LogService.shared.info(message: "Application moved from background to inactive: \(#function)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LogService.shared.info(message: "Application moved from background to not running: \(#function)")
    }

    // MARK: - Private Methods

    private func createFiles() {
        gcdService.createFile(with: Constants.userDataFileName)
        gcdService.createFile(with: Constants.themeDataFileName)
    }

    private func setupTheme() {
        themeService.fetch()
    }

    private func setupAuth() {
        AuthService.shared.configure()
    }
}

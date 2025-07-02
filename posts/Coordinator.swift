//
//  Coordinator.swift
//  posts
//
//  Created by Heawon Seo on 7/1/25.
//

import Foundation
import SwiftUI

protocol SceneBuilder {
    var path: NavigationPath { get set }
    var alert: Alert? { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    
    func buildInitialScene() -> AnyView
    func buildScene(scene: AppScene) -> AnyView
    
    func buildAlert(alert: Alert) -> AnyView
    func buildSheet(sheet: Sheet) -> AnyView
    func buildCover(cover: FullScreenCover) -> AnyView
}

protocol Navigator: AnyObject {
    func push(_ scene: AppScene)
    func pop()
    func popToRoot()
    
    func presentAlert(_ alert: Alert)
    func presentSheet(_ sheet: Sheet)
    func presentFullScreenCover(_ cover: FullScreenCover)
    func dismissAlert(alert: Alert)
    func dismissSheet()
    func dismissCover()
}

typealias Coordinator = SceneBuilder & Navigator

enum AppScene: Hashable {
    case LIST
    case DETAIL(Int)
    case CREATE
}

enum Alert {
    var title: String {
        switch self {
        case .DONE:
            return "Notice"
        case .ERROR:
            return "Error"
        }
    }
    
    case DONE(_ obj: Any)
    case ERROR(_ msg: String)
}

enum Sheet: String, Identifiable {
    var id: String { self.rawValue }
    
    case TEST
}

enum FullScreenCover: String, Identifiable {
    var id: String { self.rawValue }
    
    case LOADING
}


@Observable
final class DefaultCoordinator: Coordinator {
    
    var path: NavigationPath
    var alert: Alert?
    var sheet: Sheet?
    var fullScreenCover: FullScreenCover?
    
    @ObservationIgnored private let injector: Injector
    @ObservationIgnored private let initialScene: AppScene
    
    init(injector: Injector, initialScene: AppScene) {
        path = NavigationPath()
        alert = nil
        sheet = nil
        fullScreenCover = nil
        
        self.injector = injector
        self.initialScene = initialScene
    }
    
    func buildInitialScene() -> AnyView { return buildScene(scene: initialScene) }
    
    func buildScene(scene: AppScene) -> AnyView {
        switch scene {
        case .LIST:
            let listVM = injector.resolve(ListVM.self, argument: self as Navigator)
            return AnyView(ListView(vm: listVM))
            
        case .DETAIL(let postId):
            let detailVM = injector.resolve(DetailVM.self, argument: postId)
            return AnyView(DetailView(vm: detailVM))
            
        case .CREATE:
            let createVM = injector.resolve(CreateVM.self, argument: self as Navigator)
            return AnyView(CreateView(vm: createVM))
        }
    }
    
    func buildAlert(alert: Alert) -> AnyView {
        switch alert {
        case .DONE:
            return AnyView(Text("Success!"))
            
        case .ERROR(let msg):
            return AnyView(Text(msg))
        }
    }
    
    func buildSheet(sheet: Sheet) -> AnyView {
        switch sheet {
        case .TEST:
            return AnyView(EmptyView())
        }
    }
    
    func buildCover(cover: FullScreenCover) -> AnyView {
        switch cover {
        case .LOADING:
            return AnyView(SpinnerView())
        }
    }
    
    func push(_ scene: AppScene) { path.append(scene) }
    
    func pop() { path.removeLast() }
    
    func popToRoot() { path.removeLast(path.count) }
    
    func presentAlert(_ alert: Alert) { self.alert = alert }
    
    func presentSheet(_ sheet: Sheet) { self.sheet = sheet }
    
    func presentFullScreenCover(_ cover: FullScreenCover) { self.fullScreenCover = cover }
    
    func dismissAlert(alert: Alert) {
        if case .DONE(let obj) = alert, let newPost = obj as? Post {
            let listVM = injector.resolve(ListVM.self, argument: self as Navigator)
            listVM.posts.insert(newPost, at: 0)
            listVM.phase = .LOADED(listVM.posts)
            
            self.alert = nil
            popToRoot()
            
        } else {
            self.alert = nil
        }
    }
    
    func dismissSheet() { sheet = nil }
    
    func dismissCover() { fullScreenCover = nil }
    
}

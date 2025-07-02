//
//  postsApp.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI
import Swinject

@main
struct postsApp: App {
    
    @State private var coordinator: Coordinator
    
    init() {
        let injector = DefaultInjector(container: Container())
        injector.assemble([
            ListViewModelAssembly(),
            DetailViewModelAssembly(),
            CreateViewModelAssembly()
        ])
        
        _coordinator = .init(wrappedValue: DefaultCoordinator(injector: injector, initialScene: .LIST))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.buildInitialScene()
                    .navigationDestination(for: AppScene.self) { scene in
                        coordinator.buildScene(scene: scene)
                    }
                    .alert(
                        coordinator.alert?.title ?? "Notice",
                        isPresented: Binding(
                            get: { coordinator.alert != nil },
                            set: { if !$0 { coordinator.alert = nil } }
                        ),
                        presenting: coordinator.alert,
                        actions: { alert in
                            Button("OK", role: .cancel) {
                                coordinator.dismissAlert(alert: alert)
                            }
                        },
                        message: { alert in
                            coordinator.buildAlert(alert: alert)
                        }
                    )
                    .sheet(
                        item: $coordinator.sheet,
                        onDismiss: {
                            coordinator.dismissSheet()
                        },
                        content: { item in
                            coordinator.buildSheet(sheet: item)
                        }
                    )
                    .fullScreenCover(
                        item: $coordinator.fullScreenCover,
                        onDismiss: {
                            coordinator.dismissCover()
                        },
                        content: { item in
                            coordinator.buildCover(cover: item)
                        }
                    )
                    .transaction { transaction in
                        transaction.disablesAnimations = true
                    }
            }
        }
    }
}

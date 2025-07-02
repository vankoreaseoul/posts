//
//  Injector.swift
//  posts
//
//  Created by Heawon Seo on 7/1/25.
//

import Swinject

protocol DependencyRegisterable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ type: T.Type, _ object: T)
}

protocol DependencyResolvable {
    func resolve<T>(_ type: T.Type) -> T
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T 
}

typealias Injector = DependencyRegisterable & DependencyResolvable


final class DefaultInjector: Injector {
    
    private let container: Container
    
    init(container: Container) { self.container = container }
    
    func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach { $0.assemble(container: container) }
    }
    
    func register<T>(_ type: T.Type, _ object: T) {
        container.register(type) { _ in object }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(type)!
    }
    
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        container.resolve(type, argument: argument)!
    }
}

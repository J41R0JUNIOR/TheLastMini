//
//  Extension.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 31/07/24.
//

import Foundation
import RealityKit
import SceneKit

extension SCNNode {
    private struct AssociatedKeys {
        static var components = "components"
    }
    
    private var components: [Component] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.components) as? [Component] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.components, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addComponent(_ component: Component) {
        var currentComponents = self.components
        currentComponents.append(component)
        self.components = currentComponents
    }
    
    func getComponent<T>(ofType type: T.Type) -> T? {
        return components.first { $0 is T } as? T
    }
}

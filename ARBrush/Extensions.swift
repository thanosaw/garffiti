//
//  Extensions.swift
//  ARBrush
//
//  Created by Andrew Wang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//
import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }
    public var height: CGFloat {
        return frame.size.height
    }
    public var top: CGFloat {
        return frame.origin.y
    }
    public var bottom: CGFloat {
        return frame.origin.y+frame.size.height
    }
    public var left: CGFloat{
        return frame.origin.x
    }
    public var right: CGFloat{
        return frame.origin.x + frame.size.width
    }
}
extension String {
    func safeDatabaseKey() -> String{

        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}

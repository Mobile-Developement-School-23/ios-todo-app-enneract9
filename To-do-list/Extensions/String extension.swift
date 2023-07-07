//
//  String extension.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

extension String {
    var attributedStringStrikedThrough: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        // string striked text attribure
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 2,
            range: NSRange(location: 0, length: attributedString.length)
        )
        // string color attribute
        attributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.labelTertiary,
            range: NSRange(location: 0, length: attributedString.length)
        )

        return attributedString
    }
    
    var attributedStringEmptyAttributes: NSAttributedString {
        return NSAttributedString(string: self)
    }
}

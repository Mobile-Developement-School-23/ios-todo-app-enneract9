//
//  Date extension.swift
//  To-do-list
//
//  Created by @_@
//

import Foundation

private let dateFormatter: DateFormatter = {
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "Ru_ru")
     dateFormatter.dateFormat = "dd MMMM yyyy"
    
     return dateFormatter
 }()

private let croppedDateFormatter: DateFormatter = {
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "Ru_ru")
     dateFormatter.dateFormat = "dd MMMM"
    
     return dateFormatter
 }()

extension Date {
    var toString: String { dateFormatter.string(from: self) }
}

extension Date {
    var toStringCropped: String { croppedDateFormatter.string(from: self) }
}

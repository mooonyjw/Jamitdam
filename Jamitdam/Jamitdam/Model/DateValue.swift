//
//  DateValue.swift
//  Jamitdam
//
//  Created by Jueun Son on 11/7/24.
//

import Foundation
import SwiftUI

// Date Value Model
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}


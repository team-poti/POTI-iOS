//
//  String+.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/20/26.
//

import UIKit

extension String {
    
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        formatter.dateFormat = "yyyy-MM-dd H:mm"
        return formatter.string(from: date)
    }
}

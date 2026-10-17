//
//  Foundation+SwiftHub.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation

extension Int {

    func sizeFromKB() -> String {
        return (self*1024).sizeFromByte()
    }

    func sizeFromByte() -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }

    func kFormatted() -> String {
        let sign = ((self < 0) ? "-" : "" )
        if self < 1000 {
            return "\(sign)\(self)"
        }
        let num = fabs(self.double)
        let exp: Int = Int(log10(num) / 3.0 )
        let units: [String] = ["K", "M", "G", "T", "P", "E"]
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
}

extension String {

    /// Parses an ISO 8601 date, e.g. "2011-01-26T19:01:12Z"
    func toISODate() -> Date? {
        return Date.iso8601Formatter.date(from: self) ?? Date.iso8601FractionalFormatter.date(from: self)
    }
}

extension Date {

    fileprivate static let iso8601Formatter = ISO8601DateFormatter()

    fileprivate static let iso8601FractionalFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let relativeFormatter = RelativeDateTimeFormatter()

    func toISO() -> String {
        return Date.iso8601Formatter.string(from: self)
    }

    /// Time relative to now, e.g. "2 hours ago"
    func toRelative() -> String {
        return Date.relativeFormatter.localizedString(for: self, relativeTo: Date())
    }
}

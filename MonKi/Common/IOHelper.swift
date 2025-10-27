//
//  IOHelper.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

final class IOHelper {
    static func expandTags(_ tags: String) -> [String] {
        return tags.split(separator: ";").map { String($0) }
    }
    
    static func combineTag(_ strings: [String]) -> String {
        return strings.joined(separator: ";")
    }
}

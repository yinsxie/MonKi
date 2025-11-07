//
//  TextFieldModalProtocol.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 05/11/25.
//

import Foundation

protocol TextFieldModalProtocol {
    var title: String { get }
    var placeholder: String { get }
    var maxCharacters: Int { get }
    var cancelButtonTitle: String { get }
    var saveButtonTitle: String { get }
}

//
//	Permission.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

// MARK: - Permission
public struct Permission: Glossy {

	public let admin : Bool!
	public let pull : Bool!
	public let push : Bool!

	// MARK: Decodable
	public init?(json: JSON) {
		admin = "admin" <~~ json
		pull = "pull" <~~ json
		push = "push" <~~ json
	}

	// MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"admin" ~~> admin,
		"pull" ~~> pull,
		"push" ~~> push
		])
	}
}

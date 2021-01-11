//
//  PromoCodeModule.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import Fluent
import ViperKit

final class PromoCodeModule: ViperModule {

    static var name: String = "promo_code"

    var router: ViperRouter? { PromoCodeRouter() }

    var migrations: [Migration] {
        [
            PromoCodeMigration_v1_0_0(),
        ]
    }
}

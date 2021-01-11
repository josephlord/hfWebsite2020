//
//  PromoCodeRouter.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import ViperKit

final class PromoCodeRouter: ViperRouter {

    let controller = PromoCodeFrontendController()

    func boot(routes: RoutesBuilder, app: Application) throws {

        routes.get("example", use: self.controller.exampleView)
    }
}

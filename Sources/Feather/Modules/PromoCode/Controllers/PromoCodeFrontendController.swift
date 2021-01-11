//
//  PromoCodeFrontendController.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import Fluent

final class PromoCodeFrontendController {

    func exampleView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let foo: String
        }
        let context = Context(foo: "This is just an example")
        return req.view.render("PromoCode/Frontend/Example", context)
    }

}

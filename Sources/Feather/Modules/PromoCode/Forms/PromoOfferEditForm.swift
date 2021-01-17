//
//  File.swift
//  
//
//  Created by Joseph on 16/01/2021.
//

import FeatherCore

final class PromoOfferEditForm: ModelForm {
    typealias Model = PromoOfferModel
    
    var modelId: UUID?
    var name = FormField<String>(key: "name").required().length(max: 250)
    var description = FormField<String>(key: "description").required()
    var expiry = FormField<Date>(key: "expiry")
    var notification: String?
    var codeCount: Int?
    
    var metadata: Metadata?
    
    var fields: [FormFieldRepresentable] {
        [name, description, expiry]
    }
    
    var leafData: LeafData {
        .dictionary([
            "modelId" : modelId?.encodeToLeafData() ?? .string(nil),
            "fields" : fieldsLeafData,
            "metadata" : metadata?.leafData,
        ])
    }
        
    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        var metadataFuture = req.eventLoop.future()
        var codeCountfuture = req.eventLoop.future()
        if let id = modelId {
            metadataFuture = Model.findMetadata(reference: id, on: req.db).map { [unowned self] in metadata = $0 }
            codeCountfuture = PromoCodeModel
                .query(on: req.db)
                .join(parent: \.$offer)
                .filter(PromoOfferModel.self, \.$id == id).count()
                .map { [unowned self] in codeCount = $0 }
        }
        return req.eventLoop.flatten([
            metadataFuture,
            codeCountfuture,
        ])
    }
    
    func read(from input: Model)  {
        name.value = input.name
        description.value = input.description
        expiry.value = input.expiry
    }
    
    func write(to output: Model) {
        output.name = name.value!
        output.description = description.value ?? ""
        output.expiry = expiry.value ?? Date()
    }

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
//        var future = req.eventLoop.future()
//        if modelId != nil {
//            future = req.eventLoop.flatten([
//                BlogPostCategoryModel.query(on: req.db).filter(\.$post.$id == modelId!).delete(),
//                BlogPostAuthorModel.query(on: req.db).filter(\.$post.$id == modelId!).delete(),
//            ])
//        }
//
//        return future.flatMap { [unowned self] in
//            req.eventLoop.flatten([
//                categories.values.map { BlogPostCategoryModel(postId: model.id!, categoryId: $0) }.create(on: req.db),
//                authors.values.map { BlogPostAuthorModel(postId: model.id!, authorId: $0) }.create(on: req.db),
//            ])
//        }
    }
}

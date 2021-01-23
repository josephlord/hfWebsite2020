//
//  File.swift
//  
//
//  Created by Joseph on 16/01/2021.
//

import FeatherCore

extension FormField where Value == String {

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "y-mm-d"
        return f
    }()
    
    var dateValue: Date? {
        get {
            self.value.flatMap { Self.dateFormatter.date(from: $0) }
        }
        set {
            self.value = newValue.flatMap { Self.dateFormatter.string(from: $0) } ?? ""
        }
    }
    
    static func isValidDate(field: FormField<String>) -> Bool {
        field.value != nil
    }
}

final class PromoOfferEditForm: ModelForm {
    typealias Model = PromoOfferModel
    
    var modelId: UUID?
    var name = FormField<String>(key: "name").required().length(max: 250)
    var description = FormField<String>(key: "description").required()
    var expiry: FormField<String> = {
        let field = FormField<String>(key: "expiry").length(max: 20)
        field.validators = [FormField<String>.isValidDate]
        return field
    }()
    var codes = FormField<String>(key: "codes")
    var notification: String?
    var codeCount: Int?
    
    var metadata: Metadata?
    
    var fields: [FormFieldRepresentable] {
        [name, description, expiry, codes]
    }
    
    var leafData: LeafData {
        .dictionary([
            "modelId" : modelId?.encodeToLeafData() ?? .string(nil),
            "fields" : fieldsLeafData,
            "metadata" : metadata?.leafData,
            "notification" : .string(notification),
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
                .filter(\.$offer == id)
                .count()
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
        expiry.dateValue = input.expiry
    }
    
    func write(to output: Model) {
        output.name = name.value!
        output.description = description.value ?? ""
        output.expiry = expiry.dateValue ?? Date()
    }

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        let future = req.eventLoop.future()
        
        guard let modelId = model.id else { return future }
        let codesToAdd = codes.value?.split(separator: ",")
            .lazy
            .filter { !$0.isEmpty }
            .map { String($0) } ?? []
        return future.flatMap {
            req.eventLoop.flatten([
                req.db.transaction { db in
                    codesToAdd.map { PromoCodeModel(code: $0, offerId: modelId) }.create(on: db)
                },
            ])
        }
    }
}

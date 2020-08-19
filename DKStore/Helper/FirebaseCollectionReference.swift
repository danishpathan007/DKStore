//
//  FirebaseCollectionReference.swift
//  DKStore
//
//  Created by Danish Khan on 19/08/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference
{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

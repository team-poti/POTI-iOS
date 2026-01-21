//
//  PotDetailInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

protocol PotDetailInterface {
    func fetchPotDetail() async throws -> PotDetailEntity
}

//
//  HomeInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol HomeInterface {
    func fetchHomeData() async throws -> HomeEntity
}

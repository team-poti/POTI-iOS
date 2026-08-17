//
//  ImagePickerResultLoader.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation
import PhotosUI
import UniformTypeIdentifiers

protocol ImagePickerResultLoading {
    func loadFiles(from results: [PHPickerResult]) async throws -> [URL]
}

enum ImagePickerResultLoadingError: Error {
    case unsupportedImageType
    case failedToLoadFile
    case failedToCopyFile
}

struct ImagePickerResultLoader: ImagePickerResultLoading {
    func loadFiles(from results: [PHPickerResult]) async throws -> [URL] {
        let loadedFiles = await withTaskGroup(of: (Int, Result<URL, ImagePickerResultLoadingError>).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    do {
                        return (index, .success(try await copyImageFile(from: result.itemProvider)))
                    } catch let error as ImagePickerResultLoadingError {
                        return (index, .failure(error))
                    } catch {
                        return (index, .failure(.failedToLoadFile))
                    }
                }
            }

            var results: [(index: Int, result: Result<URL, ImagePickerResultLoadingError>)] = []
            for await result in group {
                results.append(result)
            }
            return results
        }

        let fileURLs = loadedFiles.compactMap { try? $0.result.get() }
        if let error = loadedFiles.compactMap({ result -> ImagePickerResultLoadingError? in
            guard case .failure(let error) = result.result else { return nil }
            return error
        }).first {
            fileURLs.forEach { try? FileManager.default.removeItem(at: $0) }
            throw error
        }
        return loadedFiles.sorted { $0.index < $1.index }.compactMap { try? $0.result.get() }
    }

    private func copyImageFile(from itemProvider: NSItemProvider) async throws -> URL {
        guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first(where: {
            UTType($0)?.conforms(to: .image) == true
        }) else { throw ImagePickerResultLoadingError.unsupportedImageType }

        return try await withCheckedThrowingContinuation { continuation in
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { sourceURL, error in
                guard let sourceURL else {
                    continuation.resume(throwing: error ?? ImagePickerResultLoadingError.failedToLoadFile)
                    return
                }

                let fileExtension = sourceURL.pathExtension.isEmpty ? UTType(typeIdentifier)?.preferredFilenameExtension ?? "image" : sourceURL.pathExtension
                let destinationURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension(fileExtension)

                do {
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                    continuation.resume(returning: destinationURL)
                } catch {
                    continuation.resume(throwing: ImagePickerResultLoadingError.failedToCopyFile)
                }
            }
        }
    }
}

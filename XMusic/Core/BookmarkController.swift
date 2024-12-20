//
//  BookmarkController.swift
//  XMusic
//
//  Created by eb209 on 2024/12/16.
//

import SwiftUI

class BookmarkController {
    static func addBookmark(url: URL) -> Data? {
        do {
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return nil
            }

            // Make sure you release the security-scoped resource when you finish.
            defer { url.stopAccessingSecurityScopedResource() }

            // Generate a UUID
            let uuid = UUID()

            // Convert URL to bookmark
            let bookmarkData = try url.bookmarkData(
                options: .minimalBookmark, includingResourceValuesForKeys: nil,
                relativeTo: nil)
            // Save the bookmark into a file (the name of the file is the UUID)
            try bookmarkData.write(
                to: getAppSandboxDirectory().appendingPathComponent(
                    uuid.uuidString))

            return bookmarkData
        } catch {
            // Handle the error here.
            print("Error creating the bookmark")

            return nil
        }
    }

    static func loadBookmark(bookmarkData: Data) -> URL? {
        var isStale = false

        let url = try? URL(
            resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)

        guard !isStale else {
            // Handle stale data here.
            return nil
        }

        return url
    }

    static private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[
            0]
    }
}

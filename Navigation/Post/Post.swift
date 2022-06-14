//
//  Post.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import Foundation
import MobileCoreServices
import UIKit

public let postTypeId = "com.gin.post"

enum EncodingError: Error {
    case invalidData
}

class Post: NSObject, Codable {
    //MARK: - Properties
    var title: String
    var author: String
    var image: Data?
    var descript: String
    var likes: Int
    var views: Int
    
    //MARK: - Init
    required init(
        title: String,
        author: String,
        image: Data? = nil,
        descript: String,
        likes: Int,
        views: Int
    ) {
        self.title = title
        self.author = author
        self.image = image
        self.descript = descript
        self.likes = likes
        self.views = views
    }
    
    required init(_ post: Post) {
        self.title = post.title
        self.author = post.author
        self.image = post.image
        self.descript = post.descript
        self.likes = post.likes
        self.views = post.views
        super.init()
    }
}

// MARK: - NSItemProviderWriting
extension Post: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [postTypeId, kUTTypePNG as String, kUTTypePlainText as String]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == kUTTypePNG as String {
            if let image = image {
                completionHandler(image, nil)
            } else {
                completionHandler(nil, nil)
            }
        } else if typeIdentifier == kUTTypePlainText as String {
            completionHandler(descript.data(using: .utf8), nil)
        } else if typeIdentifier == postTypeId {
            do {
                let archiver = NSKeyedArchiver(requiringSecureCoding: false)
                try archiver.encodeEncodable(self, forKey: NSKeyedArchiveRootObjectKey)
                archiver.finishEncoding()
                let data = archiver.encodedData
                completionHandler(data, nil)
            } catch {
                completionHandler(nil, nil)
            }
        }
        return nil
    }
}

// MARK: - NSItemProviderReading
extension Post: NSItemProviderReading {
    public static var readableTypeIdentifiersForItemProvider: [String] {
        return [postTypeId, kUTTypePlainText as String, kUTTypePNG as String]
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        if typeIdentifier == kUTTypePlainText as String,
           typeIdentifier == kUTTypePNG as String {
            guard let descript = String(data: data, encoding: .utf8) else {
                throw EncodingError.invalidData
            }
            guard let imageName = String(data: data, encoding: .utf8) else {
                throw EncodingError.invalidData
            }
            let imgData = UIImage(named: imageName)?.pngData()
                return self.init(title: "Title", author: "Unknown", image: imgData, descript: descript, likes: 0, views: 0)
        } else if typeIdentifier == postTypeId {
            do {
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
                guard let post = try unarchiver.decodeTopLevelDecodable(Post.self, forKey: NSKeyedArchiveRootObjectKey) else {
                    throw EncodingError.invalidData
                }
                return self.init(post)
            } catch {
                throw EncodingError.invalidData
            }
        } else {
            throw EncodingError.invalidData
        }
    }
}

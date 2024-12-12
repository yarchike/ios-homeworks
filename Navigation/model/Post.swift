
import Foundation

public struct Post: Equatable {
    public let id: String
    public let author: Author
    public let postDescription: String
    public let urlImage: String
    public var likes: Int
    public let createdAt: Date

    public init(id: String, author: Author, postDescription: String, urlImage: String, likes: Int, createdAt: Date) {
        self.id = id
        self.author = author
        self.postDescription = postDescription
        self.urlImage = urlImage
        self.likes = likes
        self.createdAt = createdAt
    }

    public func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "author": author.toDictionary(),
            "postDescription": postDescription,
            "urlImage": urlImage,
            "likes": likes,
            "createdAt": createdAt.timeIntervalSince1970
        ]
    }

    public init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let authorDict = dictionary["author"] as? [String: Any],
            let author = Author(dictionary: authorDict),
            let postDescription = dictionary["postDescription"] as? String,
            let urlImage = dictionary["urlImage"] as? String,
            let likes = dictionary["likes"] as? Int,
            let createdAtTimestamp = dictionary["createdAt"] as? TimeInterval
        else {
            return nil
        }

        self.id = id
        self.author = author
        self.postDescription = postDescription
        self.urlImage = urlImage
        self.likes = likes
        self.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
    }
}

// Обновленный Author
public struct Author: Equatable {
    public let id: String
    public let name: String
    public let urlImage: String

    public init(id: String, name: String, urlImage: String) {
        self.id = id
        self.name = name
        self.urlImage = urlImage
    }

    public func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "urlImage": urlImage
        ]
    }

    public init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let urlImage = dictionary["urlImage"] as? String
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.urlImage = urlImage
    }
}


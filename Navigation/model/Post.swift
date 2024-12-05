
import Foundation

public struct Post:Equatable {
    public  let author: Author
    public let postDescription: String
    public let urlImage: String
    public let likes: Int
    
    
    public init(author: Author, postDescription: String, urlImage: String, likes: Int) {
        self.author = author
        self.postDescription = postDescription
        self.urlImage = urlImage
        self.likes = likes
    }
}
public struct Author:Equatable {
    let id: String
    let name: String
    let urlImage: String
}

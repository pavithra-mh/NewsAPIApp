//
//  SQLiteConnection.swift
//  NewsApp
//
//  Created by Mac - 1 on 04/02/21.
//

import Foundation

import Foundation
import SQLite

class SQLiteConnection{
    static var sharedInstance = SQLiteConnection()
    var db:Connection?
    
    let author = Expression<String?>("author")
    let content = Expression<String?>("content")
    let description = Expression<String?>("description")
    let publishedAt = Expression<String?>("publishedAt")
    let title = Expression<String?>("title")
    let url = Expression<String?>("url")
    let urlToImage = Expression<String?>("urlToImage")
    
    let Articles = Table("Articles")

    private init() {
        //Create a DataBase at the below Path
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            print("Error in creating connection to Database: \(error)")
        }
    }
    func createArticlesTable()    
    {
        do {
            _ = try db!.run(Articles.create(ifNotExists: true) {
                t in
                t.column(author)
                t.column(content)
                t.column(description)
                t.column(publishedAt)
                t.column(title)
                t.column(url)
                t.column(urlToImage)
            })
        } catch {
            print("Error in creating Articles: \(error)")
        }
    }
    
    
    func SaveArticles(Author:String, Content:String, Description:String, PublishedAt:String, Title:String, Url:String, UrlToImage:String) -> Bool{
            
            do {
                let insertIntoCommand = try db!.run(Articles.insert(author <- Author, content <- Content, description <- Description, publishedAt <- PublishedAt, title <- Title, url <- Url, urlToImage <- UrlToImage))
                if insertIntoCommand > 0{
                    return true
                } else {
                    return false
                }
            } catch {
                print("Error in inserting to Articles: \(error)")
                return false
            }
        }
    
    func selectAllArticles() -> [newsArticleList] {
            do {
                let databaseRowsArray = Array(try db!.prepare(Articles))
                let databaseRows = SQLiteConnection.sharedInstance.GetRows(sqlArray: databaseRowsArray)
                
                return databaseRows
            } catch {
                print(" Error in selecting all articles from Articles: \(error)")
                let obj = [newsArticleList]()
                return obj
            }
        }

       func GetRows(sqlArray: Array<Row>) -> [newsArticleList]{
           var dataModel = [newsArticleList]()
           for i in sqlArray{
            var model = newsArticleList()
               model.author = i[author]!
               model.content = i[content]!
               model.description = i[description]!
               model.publishedAt = i[publishedAt]!
               model.title = i[title]!
               model.url = i[url]!
               model.urlToImage = i[urlToImage]!
               dataModel.append(model)
           }
           return dataModel
       }

    //Delete all ARTICLES
        func deleteAll() -> Bool {
            let Query = Articles.filter((url != nil))
            
            do {
                let deleted = try db!.run(Query.delete())
                if deleted > 0{
                    return true
                }
                return false
            } catch {
                print("error deleting the old art")
                return false
            }
        }
        
}




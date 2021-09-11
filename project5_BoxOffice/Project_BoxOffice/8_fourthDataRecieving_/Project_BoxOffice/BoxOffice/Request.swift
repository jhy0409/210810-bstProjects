//
//  Request.swift
//  BoxOffice
//
//  Created by inooph on 2021/09/08.
//

import Foundation
import UIKit

let recieveMovieID: String = "DidRecieveMovies"
let DidRecievedMoviesNotification: Notification.Name = Notification.Name(recieveMovieID)

let recieveMovieDetail: String = "DidRecieveMovieDetail"
let MovieDetailNotification: Notification.Name = Notification.Name(recieveMovieDetail)

//    let testURL: String = "https://connect-boxoffice.run.goorm.io/"
func requestMoovies(_ sortType: SortType?) {
    let testURL: String = "https://connect-boxoffice.run.goorm.io/movies"
    guard let sort = sortType else { return }
    guard let url: URL = appendSubQueryBySortType(testURL, sort) else { return }
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
        guard let data = data else { return }
        do {
            let apiResponse: MovieList =  try JSONDecoder().decode(MovieList.self, from: data)
            NotificationCenter.default.post(name: DidRecievedMoviesNotification, object: nil, userInfo: ["movies":apiResponse.movies, "movieList":apiResponse])
        } catch let err {
            print("\n\n---> 🤮🤮 Request.swift / err.localizedDescription : \(err.localizedDescription)")
        }
    }
    dataTask.resume()
}


func requestMoovies(_ movieID: String) {
    guard let url: URL = appendSubQueryByMovieID(movieID) else { return }
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
        guard let data = data else { return }
        do {
            let apiResponse: MovieDetail =  try JSONDecoder().decode(MovieDetail.self, from: data)
            NotificationCenter.default.post(name: DidRecievedMoviesNotification, object: nil, userInfo: ["detail":apiResponse])
        } catch let err {
            print("\n\n---> 🤡 Request.swift / err.localizedDescription : \(err.localizedDescription)")
        }
    }
    dataTask.resume()
}




func getViewTitleFromSortType(_ sort: SortType) -> String {
    var resultString: String = ""
    switch sort {
    case .reservation:
        resultString = "예매율"
        
    case .curation:
        resultString = "큐레이션"
        
    case .openingDate:
        resultString = "개봉일"
    }
    
    return resultString
}

//connect-boxoffice.run.goorm.io/movies?order_type=1
// MARK: - [ㅇ] URL 서브쿼리 메소드 - 영화정렬 순서
func appendSubQueryBySortType(_ inputURL: String, _ sort: SortType) -> URL? {
    var resultURLString = inputURL + "?order_type="
    
    switch sort { //영화 정렬순서
    case .reservation:
        resultURLString.append("0") //0: 예매율(default)
    case .curation:
        resultURLString.append("1") //1: 큐레이션
    case .openingDate:
        resultURLString.append("2") //2: 개봉일
    }
    guard let url: URL = URL(string: resultURLString) else { return nil }
    
    return url
}

// MARK: - [ㅇ] URL 서브쿼리 메소드 - 영화세부정보, for thirdViewController
func appendSubQueryByMovieID(_ id: String) -> URL? {
    let testURL: String = "https://connect-boxoffice.run.goorm.io/movie"
    let resultURLString = testURL + "?id=\(id)"
    guard let url: URL = URL(string: resultURLString) else { return nil }
    return url
}

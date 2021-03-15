//
//  BoardUpdateModel.swift
//  moca
//
//  Created by Ria Song on 2021/03/01.
//

import Foundation

class BoardUpdateModel:NSObject{
    
    // MARK: Img Upload
    func buildBody(with fileURL: URL, parameters: [String: String]?) -> Data? {
        // 파일을 읽을 수 없다면 nil을 리턴
        guard let filedata = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        // 바운더리 값을 정하고, 각 파트의 헤더가 될 라인들을 배열로 만든다.
        // 이 배열을 \r\n 으로 조인하여 한 덩어리로 만들어서 데이터로 인코딩한다.
        let boundary = "XXXXX"
        let mimetype = "image/jpeg"
        let headerLines = ["--\(boundary)",
                           "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"",
                           "Content-Type: \(mimetype)",
                           "\r\n"]
        var data = headerLines.joined(separator:"\r\n").data(using:.utf8)!
        
        // 그 다음에 파일 데이터를 붙이고
        data.append(contentsOf: filedata)
        data.append(contentsOf: "\r\n".data(using: .utf8)!)
        
        // 일반적인 데이터 넣을때 사용하는 폼
        // --\(boundary)\r\n
        // Content-Disposition: form-data; name=\"값\"\r\n\r\n
        // 내용\r\n
        let lines = ["--\(boundary)","Content-Disposition: form-data; name=\"name\"\r\n","values\r\n"]
        data.append(contentsOf: lines.joined(separator: "\r\n").data(using: .utf8)!)
        /*
         if parameters != nil {
         for (key, value) in parameters! {
         let lines = ["--\(boundary)","Content-Disposition: form-data; name=\"\(key)\"\r\n","\(value)\r\n"]
         data.append(contentsOf: lines.joined(separator: "\r\n").data(using: .utf8)!)
         }
         }
         */
        
        // 마지막으로 데이터의 끝임을 알리는 바운더리를 한 번 더 사용한다.
        // 이는 '새로운 개행'이 필요하므로 앞에 \r\n이 있어야 함에 유의 한다.
        data.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        return data
    }
    
    func uploadImageFile(boardNo: String, boardTitle: String, boardContent: String, at filepath: URL, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        
        // 경로를 준비하고
        var url = "http://" + Share.macIP + "/moca/jsp/board_image_update.jsp"
        let urlAdd = "?boarNo=\(boardNo)&boardTitle=\(boardTitle)&boardContent=\(boardContent)"
        print("image Update 시작 ----> \(boardNo),\(boardTitle),\(boardContent)")
        url = url + urlAdd
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlURL = URL(string: url)
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        
        let parameters = [
            "name" : ""
            //"title" : String(title),
            //"content" : String(content),
            //            "insertDate" : ""
            //            "User_uSeqno" : String(USERSEQNO),
            //            "Recipe_rSeqno" : String(RECIPESEQNO)
        ]
        
        // 경로로부터 요청을 생성한다. 이 때 Content-Type 헤더 필드를 변경한다.
        var request = URLRequest(url: urlURL!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\"XXXXX\"",
                         forHTTPHeaderField: "Content-Type")
        
        // 파일URL로부터 multipart 데이터를 생성하고 업로드한다.
        if let data = buildBody(with: filepath, parameters: parameters) {
            let task = URLSession.shared.uploadTask(with: request, from: data){ data, res, _ in
                completionHandler(data, res)
            }
            task.resume()
        }
    }
    
    func existingImage(boardNo: String, boardTitle: String, boardContent: String, boardImg: String, completionHandler: @escaping(Data?, URLResponse?) -> Void) {

        var url = "http://127.0.0.1:8080/moca/jsp/board_exImage_update.jsp"
        let urlAdd = "?boardNo=\(boardNo)&boardTitle=\(boardTitle)&boardContent=\(boardContent)&boardImg=\(boardImg)"
        print("existing-image Update 시작 ----\(boardNo),\(boardTitle),\(boardContent),\(boardImg)")
        url = url + urlAdd
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlURL = URL(string: url)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: urlURL){data, response, _ in
             completionHandler(data, response)
         }
        task.resume() // resume()을 해줘야 task가 실행 된다.
    } // func END
    
    func nonImage(boardNo: String, boardTitle: String, boardContent: String, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        print("model : \(boardNo)")
        
        var url = "http://127.0.0.1:8080/moca/jsp/board_nonImage_update.jsp"
        let urlAdd = "?boardNo=\(boardNo)&boardTitle=\(boardTitle)&boardContent=\(boardContent)"
        print("nonimage Update 시작 ----\(boardNo),\(boardTitle),\(boardContent)")
        url = url + urlAdd
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlURL:URL = URL(string: url)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: urlURL){data, response, _ in
             completionHandler(data, response)
         }
        task.resume() // resume()을 해줘야 task가 실행 된다.
    } // func END
    
} // END

//
//  PdfWebView.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 22/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import UIKit

class PdfWebView: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var data: Data!
    var path: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: path)
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

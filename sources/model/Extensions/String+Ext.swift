//
//  String+Ext.swift
//  Brickie
//
//  Created by Léo on 16/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import UIKit


extension String {
    func isValidUrl() -> URL? {
        guard let url = URL(string:self) else {return nil}
        return UIApplication.shared.canOpenURL(url) ? url : nil
    }
}

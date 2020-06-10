//
//  Foundation+Ext.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import UIKit

func tweakTableView(on:Bool){
    UITableView.appearance().backgroundColor = on ? .clear : .systemGroupedBackground
    UITableViewHeaderFooterView.appearance().tintColor = UIColor.clear

    UITableView.appearance().separatorColor = on ? .clear : nil
    UITableViewCell.appearance().backgroundColor = on ? .clear : .secondarySystemGroupedBackground
    UITableViewCell.appearance().selectionStyle = on ? .none : .default
}

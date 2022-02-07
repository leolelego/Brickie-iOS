//
//  PreviewStore.swift
//  Brickie
//
//  Created by Brian Batchelder on 12/30/21.
//  Copyright © 2021 Homework. All rights reserved.
//

import Foundation

class PreviewStore : Store {
    override init() {
        super.init(preview: true)
        addPreviewSets()
    }
    
    func addPreviewSets() {
        let previewData = """
[
{
    \"name\":\"Rebel Blockade Runner\",
    \"category\":\"Normal\",
    \"theme\":\"Star Wars\",
    \"subtheme\":\"Ultimate Collector Series\",
    \"themeGroup\":\"Licensed\",
    \"rating\":4.5,
    \"bricksetURL\":\"https:\\/\\/brickset.com\\/sets\\/10019-1\",
    \"barcode\":{
        \"EAN\":\"5702014156852\",
        \"UPC\":\"673419012683\"
    },
    \"instructionsCount\":1,
    \"image\":{
        \"imageURL\":\"https:\\/\\/images.brickset.com\\/sets\\/images\\/10019-1.jpg\",
        \"thumbnailURL\":\"https:\\/\\/images.brickset.com\\/sets\\/small\\/10019-1.jpg\"
    },
    \"LEGOCom\":{
        \"UK\":{},
        \"CA\":{},
        \"US\":{
            \"retailPrice\":200
        },
        \"DE\":{}
    },
    \"number\":\"10019\",
    \"year\":2001,
    \"setID\":22,
    \"pieces\":1747,
    \"collection\":{
        \"qtyOwned\":0,
        \"owned\":false,
        \"notes\":\"\",
        \"wanted\":true,
        \"rating\":0
    },
},
{
    \"name\":\"The Razor Crest\",
    \"category\":\"Normal\",
    \"theme\":\"Star Wars\",
    \"subtheme\":\"The Mandalorian\",
    \"themeGroup\":\"Licensed\",
    \"collection\":{
        \"qtyOwned\":1,
        \"owned\":true,
        \"notes\":\"\",
        \"wanted\":false,
        \"rating\":0
    },
    \"rating\":4.5,
    \"bricksetURL\":\"https:\\/\\/brickset.com\\/sets\\/75292-1\",
    \"barcode\":{
        \"EAN\":\"5702016683325\"
    },
    \"instructionsCount\":2,
    \"image\":{
        \"imageURL\":\"https:\\/\\/images.brickset.com\\/sets\\/images\\/75292-1.jpg\",
        \"thumbnailURL\":\"https:\\/\\/images.brickset.com\\/sets\\/small\\/75292-1.jpg\"
    },
    \"LEGOCom\":{
        \"UK\":{
            \"retailPrice\":119.98999786376953
        },
        \"CA\":{
            \"retailPrice\":159.99000549316406
        },
        \"US\":{
            \"retailPrice\":129.99000549316406
        },
        \"DE\":{
            \"retailPrice\":129.99000549316406
        }
    },
    \"number\":\"75292\",
    \"year\":2020,
    \"minifigs\":5,
    \"setID\":29993,
    \"pieces\":1023,
},
{
    \"collection\":{\"qtyOwned\":1,
        \"owned\":true,
        \"notes\":\"\",
        \"wanted\":false,
        \"rating\":0},
        \"category\":\"Normal\",
        \"theme\":\"Star Wars\",
        \"themeGroup\":\"Licensed\",
        \"rating\":4.3000001907348633,
        \"bricksetURL\":\"https:\\/\\/brickset.com\\/sets\\/75255-1\",
        \"barcode\":{\"EAN\":\"5702016370775\",
        \"UPC\":\"673419304405\"},
        \"instructionsCount\":2,
        \"image\":{\"imageURL\":\"https:\\/\\/images.brickset.com\\/sets\\/images\\/75255-1.jpg\",
        \"thumbnailURL\":\"https:\\/\\/images.brickset.com\\/sets\\/small\\/75255-1.jpg\"},
        \"LEGOCom\":{\"UK\":{\"retailPrice\":89.989997863769531},
        \"CA\":{\"retailPrice\":139.99000549316406},
        \"US\":{\"retailPrice\":99.989997863769531},
        \"DE\":{\"retailPrice\":99.989997863769531}},
        \"number\":\"75255\",
        \"year\":2019,
        \"minifigs\":1,
        \"setID\":29355,
        \"pieces\":1771,
        \"name\":\"Yoda\",
        \"subtheme\":\"Episode III\"
    }
]
"""
        do {
            let data = previewData.data(using: .utf8)
            let items = try JSONDecoder().decode([LegoSet].self, from: data!)
            self.append(items)
        } catch {
            log("Error loading preview data")
            logerror(error)
        }
    }
}

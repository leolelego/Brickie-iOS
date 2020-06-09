# Emmet: Your BrickSet Companion for iOS

Emmet is an iOS application powered by the BrickSet API which permit to make a collection of your LEGO sets and minifigures. 

## Open Source, Technologies and Privacy

As this project is a side project I decided to use the last new tech made by Apple to do it. So it's full of SwiftUI, Combine and SDKs are powered by Swift Package Manager. 

This project is Open source and I will love you to give me help to imporve this app. If you knows some Swift and iOS things, feel free to fork and make any PR! I will review them with pleasure. 
Please don't copy this app, I do open-source to offert something create to LEGO fans like me, the app is free, so help to make it awesome! 

You don't know sh*t about iOS, no worries, tell me any ideas you have thought a **Github Issue** and I will do my best if it's revelant!

### Privacy Policy

**We do not collect any of your data**. The only data collected is collected from within the app itself and only stored locally like your owned and wanted sets.figs. 
We don't dislay any ads or send anything to any server. So we don't track you using an advertising identifier or anything of the sort. 



## How to Compile and Run

#### Pre-requisits

- a macOS Catalina 
- Xcode 11.4.1 Minimum
- an account at [BrickSet](https://brickset.com) and [request an API key](https://brickset.com/tools/webservices/v3)
- an Apple Developer Account (even Free) 

#### Build

- clone the project
- add a `Secrets.swift` file at this path : `./sources/model` with the following content

```
  // API Key for BrickSet
  //      For  collection
  //      API key :request one in the form
  //      API Docs V3 : https://brickset.com/tools/webservices/v3
  let BrickSetApiKey = "YOUR API KEY"
```

 - change the bundle and the signing team in Xcode
 - wait that all the Swift Package are downloaded or force in Xcode via `File -> Swift Packages -> Resolve Package Version`
 - run baby! 🦄
 
 
## Credits and Thanks

Thanks first to **BrickSet** and Huw for is support in this implementation. Thanks to Will from HMWK.fr for is help and Testflight account. 

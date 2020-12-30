# Guidelines

1. [x] Use Swift 5.3
2. [x] Set target to SDK iOS 11 
3. [x] The UI must be created without the use of Xib or Storyboard, it must be dynamic and it must support both iPhone and iPad
4. [x] Use no more than 2 (two) external libraries, and motivate their use
5. [x] You can use CocoaPods, Carthage or SwiftPM; provide motivation for your choice
6. [x] Use MVVM pattern
7. [x] Verify build completes successfully before considering the project complete!
8. [x] Publish code on a github public repository, or in a zip archive
9. [x] Create a README.md file collecting your implementation choices motivations

I didn't have the opportunity to test the application on iOS 11 for technical reasons.

# Motivations

My main motivation is a limited amount of time. I use tools and frameworks I'm most familiar with to speed up the development.  

## Dependency management

Usually I prefer to work with official tools, like SPM, but it doesn't work well with the dynamic linking in Xcode, so I chose CocoaPods because it's easy to set up and supports dynamic linking.  

## Architecture

* Since there was a requirement to use MVVM, I've added RxSwift for bindings.
* For offline mode I've implemented a simple file caching.
* I thought it would be great to implement the paginated loading ot the list, but there was no time for it.
* I use stack views to reduce the amount of counstaints I have to set manually.  
* I use modules to hide the implementation details from the all layer.

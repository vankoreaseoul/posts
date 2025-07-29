# Posts
Posts is an iOS app that allows users to view and create posts using the [JSONPlaceholder](https://jsonplaceholder.typicode.com/) public API.<br>
It also uses [Picsum Photos](https://picsum.photos/) to load sample images in the detail view.

## Development Info
* Developer: Heawon Seo
* Development Period: 28 May 2025 – 07 July 2025

## Tech Stack
### Language
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
### Framework
![SwiftUI](https://img.shields.io/badge/SwiftUI-0C1E2C?style=for-the-badge&logo=swift&logoColor=white)
### Language Features
![SwiftConcurrency](https://img.shields.io/badge/SwiftConcurrency-228B22?style=for-the-badge&logo=apple&logoColor=white)
### Libraries
![Moya](https://img.shields.io/badge/Moya-1C1C1E?style=for-the-badge&logo=apple&logoColor=white)
![Kingfisher](https://img.shields.io/badge/Kingfisher-228B22?style=for-the-badge&logo=apple&logoColor=white)
![Swinject](https://img.shields.io/badge/SWINJECT-6A5ACD?style=for-the-badge&logo=swift&logoColor=white)
### Architecture
![MVVM-C](https://img.shields.io/badge/MVVM--C-blueviolet)

## UI Overview
![Simulator Screen Recording - iPhone 16 - 2025-07-29 at 13 42 48 (1)](https://github.com/user-attachments/assets/e6db48d0-fb36-41a1-9da6-640c9fbe701e)

## Architecture
```
posts
  ├── Data
  │     ├── Model
  │     │     ├── Post
  │     │     └── Comment
  │     └── Repository
  │           ├── PostAPI
  |           ├── PostRepository
  │           └── ImageRepository
  ├── DI
  │    ├── Assembly
  │    └── Injector
  ├── Usecase
  │      ├── GetPostsService
  │      ├── GetPostDetailService
  │      └── CreatePostService
  ├── Utils
  │     ├── Constant
  │     ├── Extension
  │     └── ViewStyles
  ├── View
  │     ├── Common
  │     │     ├── ListRowLoadingView
  |     |     ├── NoticelView
  │     │     └── SpinnerView
  |     ├── Create
  │     │     └── CreateView
  │     ├── Detail
  │     │     ├── Child
  │     │     │    ├── CommentView
  │     │     │    └── ImageView      
  │     │     └── DetailView
  │     └── List
  │           ├── Child
  │           |     └── ListRowView   
  │           └── ListView
  ├── ViewModel
  │       ├── ListVM
  │       ├── DetailVM
  │       └── CreateVM
  ├── Coordinator
  ├── Error
  ├── Info
  ├── LaunchScreen
  └── postsApp
```

## Features

- **Skeleton Loading View** for smooth UX during data fetch
- **Coordinator pattern** for managing navigation outside of views
- **Swift Concurrency with cancelable `Task`**, using `task.cancel()` to avoid unwanted async work
- **Modern State Management** using Swift 6's `@Observable` and `@State` macros to replace `@ObservedObject` / `@StateObject`


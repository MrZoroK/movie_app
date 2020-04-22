# movie_app
1. DESCRIPTION: a simple app to display movies info from themoviedb.org

2. REQUIREMENTS:
    - Create the layout axactly like the design provided at:
    https://www.figma.com/file/FrVMAtZUuJSLujJZ2uJ4mF/Movie-app?node-id=0%3A1
    - Font-family is Helvetica
    - All infomation got from: https://developers.themoviedb.org/3
    - The lists in home screen must support:
        + Load more
        + Pull to refresh

3. SETUP:
    - Install flutter, use stable channel
    - At the first time, run "flutter pub run build_runner build"
        -> This will generate JsonSerializable models
        -> Also need to run when have any change of model structures

4. DESIGN PATTERNS:
    - Use Bloc: to architect the project. The diagram should look like:
    -------------------------------------------------------------------
                                                |====> ApiProvider
        UI <=====> Bloc <=====> Repository <====|
                                                |====> CacheProvider
    -------------------------------------------------------------------

    - Dependency Injection: use GetIt - a simple service locator
    - State Management: use Provider, Streaming (rxdart) to handle the update scenario of a model/widget

5. BEST PRACTICES:
    - Use SVG file for assets when applicable
      --> For better scaling on large screen resolution
    - Use Isolate(threading in Flutter) for parsing large json files
      --> To reduce micro-freeze while fetching data in the background
    - Caching assets for network requests based on "cache-control", "etag" responded from server
      --> Can use the app even when offline or API service down


6. PROBLEMS:
    - API doesn't provide me (or maybe I can't find yet) some info below according to the mockup:
        + (1) "Comments" section in Detail screen:
                --> No user's avatar, the rating number, and the date reviewed
        + (2) "Category" section in Home screen:
                --> No background picture for each category
    - (3) Video section: the Video Player plugin provided by Flutter team doesn't support to play youtube videos
7. SOLUTIONS:
    - (1) Fetched user's comments info by loading and parsing html page from https://www.themoviedb.org/movie/<id>-<title>/reviews
    - (2) No solution for the pictures of Category
    - (3) Build an API using Node.js on google cloud function to get MP4 stream from youtube link
        + API url: https://us-central1-get-utube-link.cloudfunctions.net/getYoutubeDownloadInfo?video_id=<youtube_id>
        + Use 3rd party package to build it: https://www.npmjs.com/package/ytdl-core

8. KNOWN ISSUES:
    - Use gradiant background color for CATEGORY as API doesn't provide background picture
    - Text displaying on the app would be sightly different with the mockup since the requirement asks to use Helvetica font, but the mockup use 2 different fonts: Open Sans and Helvetica

9. UNIT TESTS: 
    Only provide tests for the api provider, model parser


10. Third party packages:
    get_it:                     https://pub.dev/packages/get_it
    json_annotation:            https://pub.dev/packages/json_annotation
    flutter_svg:                https://pub.dev/packages/flutter_svg
    cached_network_image:       https://pub.dev/packages/cached_network_image
    rxdart:                     https://pub.dev/packages/rxdart
    shimmer:                    https://pub.dev/packages/shimmer
    provider:                   https://pub.dev/packages/provider
    video_player:               https://pub.dev/packages/video_player
    flutter_cache_manager:      https://pub.dev/packages/flutter_cache_manager
    path_provider:              https://pub.dev/packages/path_provider


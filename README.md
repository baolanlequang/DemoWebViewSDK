# DemoWebViewSDK

## Create XCFramework

```
xcodebuild archive \
-scheme DemoWebViewSDK \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/DemoWebViewSDK.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
```

```
xcodebuild archive \
-scheme DemoWebViewSDK \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/DemoWebViewSDK.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
```

```
xcodebuild archive \
-scheme DemoWebViewSDK \
-configuration Release \
-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
-archivePath './build/DemoWebViewSDK.framework-catalyst.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
```

```
xcodebuild -create-xcframework \
-framework './build/DemoWebViewSDK.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/DemoWebViewSDK.framework' \
-framework './build/DemoWebViewSDK.framework-iphoneos.xcarchive/Products/Library/Frameworks/DemoWebViewSDK.framework' \
-framework './build/DemoWebViewSDK.framework-catalyst.xcarchive/Products/Library/Frameworks/DemoWebViewSDK.framework' \
-output './build/DemoWebViewSDK.xcframework'
```

## Release to Cocoapod
```
pod trunk push DemoSDK.podspec --skip-import-validation --allow-warnings
```

# React Native Photo Viewer

> A photo viewer for react native build on top of [NYTPhotoViewer](https://github.com/NYTimes/NYTPhotoViewer) and [FrescoImageViewer](https://github.com/stfalcon-studio/FrescoImageViewer)

**Key features:**

- Double-tap to zoom
- Captions and summaries
- Support for multiple images
- Interactive flick to dismiss
- Animated zooming presentation
- Support remote image and local image or images from Camera Roll
- And more...

## TOC

- [React Native Photo Viewer](#react-native-photo-viewer)
	- [TOC](#toc)
	- [Getting started](#getting-started)
		- [Mostly automatic installation](#mostly-automatic-installation)
		- [Manual installation](#manual-installation)
			- [iOS](#ios)
			- [IOS Link Frameworks](#ios-link-frameworks)
				- [Manual link](#manual-link)
				- [CocoaPods](#cocoapods)
				- [Carthage](#carthage)
			- [Android](#android)
			- [Android targetSdkVersion configuration](#android-targetsdkversion-configuration)
			- [Android Fresco initialize](#android-fresco-initialize)
	- [Usage](#usage)
	- [Known issues](#known-issues)
	- [LICENSE](#license)
	
	
<img width="375" alt="20170728-110148@2x" src="https://user-images.githubusercontent.com/433259/88470922-102fb600-cf35-11ea-92ae-b4cafe9ab9dd.png"> ![android](https://user-images.githubusercontent.com/433259/88471006-fb9fed80-cf35-11ea-9661-e1bd58de826f.gif)


----


**Note**

If your `react-native` version is under `0.57` please use version `2.x` otherwise please use the latest version




## Getting started

`$ npm install @merryjs/photo-viewer --save`

or

`$ yarn add @merryjs/photo-viewer`

### Mostly automatic installation

`$ react-native link @merryjs/photo-viewer`

When you done this you still need link some frameworks into your xcode's embedded framework section,
here you have some choices please see [IOS link frameworks](#ios-link-frameworks) for more details

and initialize Fresco Library please see [Android Fresco initialize](#android-fresco-initialize)

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@merryjs/photo-viewer` and add `MerryPhotoViewer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libMerryPhotoViewer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### IOS Link Frameworks

##### Manual link

For some reasons if you dont want use any package manager in your side then you can link frameworks as:

- Go to your xcode project choose your project if you unsure it click (command + 1)
- Choose target General panel find embedded binaries click + icon will display a dialog and then go to `node_modules/@merryjs/photo-viewer/ios/Carthage/Build/iOS/` folder add these frameworks into your xcode project. make sure `checked` **copy items if needed** and then It should looks like below,
  <img width="1331" alt="20170728-110148@2x" src="https://user-images.githubusercontent.com/433259/88471015-1eca9d00-cf36-11ea-870a-3f95b96bc48e.png">


##### [CocoaPods](https://cocoapods.org/)

Add `pod "NYTPhotoViewer", "~> 2.0.0"` in your `Podfile`

If you only use CocoaPods to define your react-native 3rd party libraries you can add this to you `Podfile` without linking to project as above:

```ruby
pod 'MerryPhotoViewer', path: '../node_modules/@merryjs/photo-viewer'
```

##### [Carthage](https://github.com/Carthage/Carthage)

If you want use Carthage in your project and then you can add these dependencies into your Cartfile

```
github "NYTimes/NYTPhotoViewer"
```

and run `carthage update` when you done this you can link it like Manual link from node_modules describes, the only difference is use your carthage file instead of ours

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`

- Add `import com.merryjs.PhotoViewer.MerryPhotoViewPackage;` to the imports at the top of the file
- Add `new MerryPhotoViewPackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:
   ```
   include ':@merryjs/photo-viewer'
   project(':@merryjs/photo-viewer').projectDir = new File(rootProject.projectDir, 	'../node_modules/@merryjs/photo-viewer/android')
   ```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
   ```
   compile project(':@merryjs/photo-viewer')
   ```
4. **Workaround for older gradles** please see https://github.com/merryjs/photo-viewer/issues/39

   ```
   include ':merryjs-photo-viewer'
   project(':merryjs-photo-viewer').projectDir = new File(rootProject.projectDir,'../node_modules/@merryjs/photo-viewer/android')
   ```

   ```
   compile project(':merryjs-photo-viewer')
   ```

#### Android targetSdkVersion configuration

We use a third part library and both of them are target to `targetSdkVersion 25`, so you need update your build.gradle to the same version or you will meet a build error

The configuration looks like: (`android/app/build.gradle`)

```java
android {
 compileSdkVersion 25
 buildToolsVersion "25.0.3"

 defaultConfig {
     applicationId "com.merryexamples"
     minSdkVersion 16
     targetSdkVersion 25
     versionCode 1
     versionName "1.0"
     ndk {
         abiFilters "armeabi-v7a", "x86"
     }

     renderscriptTargetApi 25
     renderscriptSupportModeEnabled true
 }
	// ...
}
```

If we have any better solution will update this section in the future.

#### Android Fresco initialize

When you have linked you need one more step for initialize the Fresco Library in `MainApplication.java`

```java

import com.facebook.drawee.backends.pipeline.Fresco; // <-- import on top of the file

// ...

@Override
public void onCreate() {
	super.onCreate();
	SoLoader.init(this, /* native exopackage */ false);

	Fresco.initialize(this);

}
```

If your pictures are very large, you can initialize with these configurations in `MainApplication.java`

```java
// Add these imports on top of the file
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.core.ImagePipelineConfig;
import com.facebook.imagepipeline.decoder.SimpleProgressiveJpegConfig;

// ...

@Override
public void onCreate() {
	super.onCreate();
	SoLoader.init(this, /* native exopackage */ false);

  ImagePipelineConfig config = ImagePipelineConfig.newBuilder(this)
    .setProgressiveJpegConfig(new SimpleProgressiveJpegConfig())
    .setResizeAndRotateEnabledForNetwork(true)
    .setDownsampleEnabled(true)
    .build();
  Fresco.initialize(this, config);
}

```

Thats all.

## Usage

The most part from this package is setup the Native side dependencies, once you have done it before,
you can use it as below, very very easy to use:

```javascript
import PhotoView from "@merryjs/photo-viewer";

// local image
const cat = require("./cat-2575694_1920.jpg");

const photos = [
  {
    source: {
      uri:
        "https://images.pexels.com/photos/45170/kittens-cat-cat-puppy-rush-45170.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
    },
    title: "Flash End-of-Life",
    summary:
      "Adobe announced its roadmap to stop supporting Flash at the end of 2020. ",
    // must be valid hex color or android will crashes
    titleColor: "#f90000",
    summaryColor: "green"
  },
  {
    source: cat,
    title: "Local image"
  },

  {
    source: {
      uri:
        "https://images.pexels.com/photos/142615/pexels-photo-142615.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
    }
  },
  {
    source: {
      uri:
        "https://images.pexels.com/photos/82072/cat-82072.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
    }
  },
  {
    source: {
      uri:
        "https://images.pexels.com/photos/248261/pexels-photo-248261.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
    }
  },
  {
    source: {
      uri: "https://media.giphy.com/media/3o6vXWzHtGfMR3XoXu/giphy.gif"
    },
    title: "gif 1"
  }
];

<PhotoView
  visible={this.state.visible}
  data={photos}
  hideStatusBar={true}
  initial={this.state.initial}
  onDismiss={e => {
    // don't forgot set state back.
    this.setState({ visible: false });
  }}
/>;
```

For complete documentation please see https://merryjs.github.io/photo-viewer/interfaces/merryphotoviewporps.html

## Known issues

- IOS not support gif well when using imageLoader Please see https://github.com/facebook/react-native/issues/15427 any help are welcome. at this moment gif image on ios platform are only display the first frame and no animation.

## LICENSE

```
Copyright 2017 Merryjs.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

Due to we use some third-part softwares and both of them are licensed under Apache 2.0 so do we.

- [Photo Viewer](https://github.com/merryjs/photo-viewer/blob/master/LICENSE)
- [NYTPhotoViewer](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/LICENSE.md)
- [FrescoImageViewer](https://github.com/stfalcon-studio/FrescoImageViewer#license)

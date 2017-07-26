
# @merryjs/photo-viewer[WIP]

> A photo viewer for react native build on top of NYTPhotoViewer

![preview](./assets/preview.gif)

## Getting started

`$ npm install @merryjs/photo-viewer --save`

### Mostly automatic installation

`$ react-native link @merryjs/photo-viewer`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@merryjs/photo-viewer` and add `MerryPhotoViewer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libMerryPhotoViewer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

##### IOS Link Frameworks

NOTE: TOOD

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.MerryPhotoViewerPackage;` to the imports at the top of the file
  - Add `new MerryPhotoViewerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':@merryjs/photo-viewer'
  	project(':@merryjs/photo-viewer').projectDir = new File(rootProject.projectDir, 	'../node_modules/@merryjs/photo-viewer/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':@merryjs/photo-viewer')
  	```


## Usage
```javascript
import MerryPhotoViewer from '@merryjs/photo-viewer';

// TODO: What to do with the module?
MerryPhotoViewer;
```

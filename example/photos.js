import React, { Component } from "react";
import {
  AppRegistry,
  StyleSheet,
  Text,
  ScrollView,
  View,
  Button,
  Image,
  TouchableOpacity,
  Dimensions,
  processColor,
  NativeModules
} from "react-native";

import PhotoView from "./photo-viewer";

const resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");

const cat = require("./cat-2575694_1920.jpg");

const photos = [
  {
    url:
      "https://images.pexels.com/photos/45170/kittens-cat-cat-puppy-rush-45170.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb",
    title: "Flash End-of-Life",
    summary:
      "Adobe announced its roadmap to stop supporting Flash at the end of 2020. ",
    // must be valid hex color or android will crashes
    titleColor: "#f90000",
    summaryColor: "green"
  },
  {
    url: resolveAssetSource(cat).uri,
    title: "Local image"
  },

  {
    url:
      "https://images.pexels.com/photos/142615/pexels-photo-142615.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
  },
  {
    url:
      "https://images.pexels.com/photos/82072/cat-82072.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
  },
  {
    url:
      "https://images.pexels.com/photos/248261/pexels-photo-248261.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
  },
  {
    url: "https://media.giphy.com/media/xT39CSUZtc1T1iKgc8/giphy.gif"
  },
  {
    url: "https://media.giphy.com/media/3o6vXWzHtGfMR3XoXu/giphy.gif"
  },
];
export default class Photos extends Component {
  static navigationOptions = {
    title: "Photo Viewer"
  };
  state = {
    visible: false,
    initial: 0
  };
  render() {
    const imageSize = Dimensions.get("window").width / 3;

    const imageStyle = {
      width: imageSize,
      height: imageSize
    };
    return (
      <View style={styles.container}>
        <Text style={styles.h1}>Photo Viewer</Text>
        <PhotoView
          visible={this.state.visible}
          data={photos}
          hideStatusBar={true}
          initial={this.state.initial}
          onDismiss={e => {
            this.setState({ visible: false });
          }}
        />
        <ScrollView showsVerticalScrollIndicator={false}>
          <View style={styles.photoContainer}>
            {photos.map((cat, index) =>
              <TouchableOpacity
                key={index}
                style={[imageStyle, {}]}
                ref={r => (this.r = r)}
                onPress={() => this.setState({ visible: true, initial: index })}
              >
                <Image style={imageStyle} source={{ uri: cat.url }} />
              </TouchableOpacity>
            )}
          </View>
        </ScrollView>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    backgroundColor: "#f5f5f5"
  },
  photoContainer: {
    flex: 1,
    flexDirection: "row",
    flexWrap: "wrap"
  },
  h1: {
    padding: 40,
    textAlign: "center",
    fontSize: 24
  }
});

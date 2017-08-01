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

import photoViewer from "./photo-viewer";

const photos = [
  {
    url: "https://c1.staticflickr.com/8/7625/16631849053_db25684173_k.jpg",
    title: "Flash End-of-Life",
    summary:
      "Adobe announced its roadmap to stop supporting Flash at the end of 2020. ",
    // must be valid hex color or android will crashes
    titleColor: "#f90000",
    summaryColor: "green"
  },
  {
    url: "https://c1.staticflickr.com/6/5598/14934282524_577a904d2b_k.jpg"
  },
  {
    url: "https://c1.staticflickr.com/8/7596/17021131801_fbd8f2b71a_k.jpg"
  },
  {
    url:
      "https://images.pexels.com/photos/45170/kittens-cat-cat-puppy-rush-45170.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"
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
			url:'https://media.giphy.com/media/xT39CSUZtc1T1iKgc8/giphy.gif'
		},
		{
			url:'https://media.giphy.com/media/3o6vXWzHtGfMR3XoXu/giphy.gif'
		}
];
export default class Photos extends Component {
  static navigationOptions = {
    title: "Photo Viewer"
  };

  async componentDidMount() {
    // await MerryPhotoViewer.config({ data: photos });
  }
  render() {
    const imageSize = Dimensions.get("window").width / 3;

    const imageStyle = {
      width: imageSize,
      height: imageSize
    };

    return (
      <View style={styles.container}>
        <Text style={styles.h1}>Photo Viewer</Text>
        <ScrollView showsVerticalScrollIndicator={false}>
          <View style={styles.photoContainer}>
            {photos.map((cat, index) =>
              <TouchableOpacity
                key={index}
                style={[imageStyle, {}]}
                ref={r => (this.r = r)}
                onPress={() =>
                  photoViewer.show({
                    hideStatusBar: true,
                    swipeToDismiss: true,
                    zooming: true,
                    data: photos,
                    initial: index,
                  })}
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

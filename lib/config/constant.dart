const API_BASE_URL = "https://api.themoviedb.org/3";
const API_KEY = "a7b3c9975791294647265c71224a88ad";
const IMAGE_BASE_URL = "https://image.tmdb.org/t/p/original";
String getFullImageUrl(String img) {
  if (img != null) {
    return IMAGE_BASE_URL + img;
  } else {
    return IMAGE_BASE_URL;
  }
}
enum MovieSection {
  TRENDING,
  POPULAR,
  TOP_RATED,
  UPCOMING,
  RECOMMENDATIONS
}

extension MovieSectionUrl on MovieSection {
  String url({int movieId}) {
    if (this == MovieSection.TRENDING) {
      return "/trending/movie/week";
    } else if (this == MovieSection.RECOMMENDATIONS) {
      return "/movie/$movieId/" + this.toStr();
    } else {
      return "/movie/" + this.toStr();
    }
  }

  String toStr() {
    return this.toString().toLowerCase().replaceAll("moviesection.", "");
  }
}
const String API_BASE_URL = "https://www.reddit.com/";

class EndPoints {
  static String getPosts(String subreddit, String filter) {
    return '${API_BASE_URL}r/$subreddit/$filter.json';
  }

  static String getSearch(String searchTerm) {
    searchTerm = searchTerm.replaceAll(' ', '%20');
    return '${API_BASE_URL}search.json?q=$searchTerm&type=link';
  }
}

final List<String> kfilterValues = [
  'Hot',
  'New',
  'Controversial',
  'Top',
  'Rising'
];

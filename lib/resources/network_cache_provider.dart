import 'package:movie_app/utils/custom_cache_manager.dart';
import 'package:http/http.dart';

class NetworkCacheProvider {
  Future<Response> get(String url, {Map<String, String> headers, bool cache = true}) async {
    var cacheManager = CustomCacheManager();
    if (!cache) {
      await cacheManager.removeFile(url);
    }
    return cacheManager.getSingleFile(url, headers: headers).then((file) async {
      if (file != null && file.existsSync()) {
        var res = file.readAsStringSync();
        return Response(res, 200, headers: { "content-type": "application/json;charset=utf-8" });
      }return Response(null, 404);
    }).catchError((err){
      return Response(null, 404);
    });
  }
  put(String url, Response resp) {
    String eTag = resp.headers['etag'];
    String maxAge = resp.headers['cache-control']?.split(',')?.firstWhere((element){
      return element.toLowerCase().contains("max-age");
    })?.trim()?.replaceAll("max-age=", "");
    int iMaxAge = 21600;
    if (maxAge != null && maxAge != ""){
      iMaxAge = int.parse(maxAge);
    }
    return CustomCacheManager().putFile(url, resp.bodyBytes, eTag: eTag, maxAge: Duration(seconds: iMaxAge));
  }
}
function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var uri = request.uri;

  // Basic認証
  // echo -n user:pass | base64
  var authString = "Basic aGlzdWk6aGlzdWlwdw==";

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } },
    };
  }

  // デフォルトディレクトリインデックス
  // Check whether the URI is missing a file name.
  if (uri.endsWith("/")) {
    request.uri += "index.html";
  }
  // Check whether the URI is missing a file extension.
  else if (!uri.includes(".")) {
    request.uri += "/index.html";
  }

  return request;
}

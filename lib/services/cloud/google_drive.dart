import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:eatery/references.dart';

const _clientId = "43263799198-3k39t047lg9rabjbefeepl045mihsdlg.apps.googleusercontent.com";
const _clientSecret = "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";
const _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(_clientId, _clientSecret), _scopes, (url) async {
        //Open Url in Browser
        await launchUrl(Uri.parse(url));
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              credentials["refreshToken"],
              _scopes));
    }
  }

  //Upload File
  Future<ga.File> upload(File file) async {
    try {
      var client = await getHttpClient();
      var drive = ga.DriveApi(client);
      var response = await drive.files.create(
          ga.File()..name = path.basename(file.absolute.path),
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
      return response;
    } catch (_) {
      await storage.clear();
      return upload(file);
    }
  }

  //Upload File
  Future<ga.File> update(File file, String fileId) async {
    try {
      var client = await getHttpClient();
      var drive = ga.DriveApi(client);
      var response = await drive.files.update(
        ga.File()..name = path.basename(file.absolute.path),
        fileId,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      return response;
    } catch (_) {
      await storage.clear();
      return update(file, fileId);
    }
  }

  Future<List<ga.File>> download(List<dynamic> ids) async {
    try {
      List<ga.File> files = [];
      var client = await getHttpClient();
      var drive = ga.DriveApi(client);
      for (String id in ids) {
        //await drive.files.export(id, mimeType);
        var file = await drive.files
            .get(id, downloadOptions: ga.DownloadOptions.fullMedia);
        files.add(file as ga.File);
      }
      return files;
    } catch (_) {
      await storage.clear();
      return download(ids);
    }
  }
}

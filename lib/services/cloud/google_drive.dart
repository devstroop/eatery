import 'dart:io';
import 'package:eatery/services/cloud/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

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
          ClientId(_clientId, _clientSecret), _scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken, authClient.credentials.refreshToken!);
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
    try{
      var client = await getHttpClient();
      var drive = ga.DriveApi(client);
      var response = await drive.files.create(
          ga.File()..name = p.basename(file.absolute.path),
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
      return response;
    }catch(_){
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
        ga.File()
          ..name = p.basename(file.absolute.path),
        fileId,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      return response;
    }catch(_){
      await storage.clear();
      return update(file, fileId);
    }
  }
  Future<List<ga.File>> download(List<dynamic> ids) async {
    try{
      List<ga.File> _files = [];
      var client = await getHttpClient();
      var drive = ga.DriveApi(client);
      for(String id in ids){
        //await drive.files.export(id, mimeType);
        var file = await drive.files.get(id, downloadOptions: ga.DownloadOptions.fullMedia);
        _files.add(file as ga.File);
      }
      return _files;
    }catch(_){
      await storage.clear();
      return download(ids);
    }
  }
}
enum WidgetStatus { initial, loading, success, error }

enum AppState { loggedUser, logOut, error }

enum StoragePath {
  files,
  profile;

  // Firebase Storage (folder path)
  String toPath() {
    switch (this) {
      case files:
        return "subject_files";
      case profile:
        return "profileImages";
    }
  }
}

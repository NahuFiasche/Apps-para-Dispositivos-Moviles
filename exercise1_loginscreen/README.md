# exercise1_loginscreen

## TheGamesDB

Game search uses TheGamesDB's `Games/ByGameName` API. The API key is supplied at
build/run time rather than stored in the source:

```shell
flutter run --dart-define=THEGAMESDB_API_KEY=your_api_key
```

For a packaged build, pass the same `--dart-define` option to the relevant
`flutter build` command. Keys included in a client app can be extracted from
the app bundle, so restrict the key's permissions/usage where possible and
avoid committing it to the repository.

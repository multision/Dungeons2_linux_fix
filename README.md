# Minecraft Dungeons II — CrossOver and account linking

A local replacement for `xgameruntime.dll` for the Steam build of Minecraft Dungeons II under CrossOver on macOS.

This combines [typester's CrossOver fixes](https://github.com/typester/Dungeons2_linux_fix/tree/crossover-fixes) at `0c53d48ed320a259bfb5c1c453904ed57fc5f49c` with the Linux parent's [PlayFab account-linking patch](https://github.com/Kubas556/Dungeons2_linux_fix/commit/c10de41). It uses the upstream Python authentication helper.

## Changes

- Accept unsupported WinHTTP decompression option 118 only when it fails with error 12009, allowing XCurl to send requests.
- Find XCurl's WinHTTP imports by name.
- Launch the Python sign-in helper natively on Apple Silicon and use the macOS browser opener.
- Use `WINE_HOST_HOME` and `LOCALAPPDATA` for host and bottle paths.
- Generate device-bound Xbox, Minecraft, and PlayFab tokens, and return the PlayFab token when the game requests `playfabapi.com`.

## Validation

The CrossOver build before the account-linking patch reached the main screen and gameplay on Apple Silicon. Steam login returned HTTP 200; Microsoft account linking returned HTTP 500.

The combined build compiled with MinGW GCC 16.2.0, its DLL exports were checked, and the helper's proof-key generation and request signing passed a local OpenSSL test. It has been installed for testing. Successful account linking with this combined build has not yet been confirmed.

GCC reports two existing warnings about long local-storage paths potentially exceeding `MAX_PATH`.

## Install on macOS

Close Minecraft Dungeons II first. The bottle's Steam client can remain open.

Install the helper where the DLL expects it:

```sh
mkdir -p ~/.local/share/dungeons2-compat
cp xauth.py ~/.local/share/dungeons2-compat/xauth.py
chmod +x ~/.local/share/dungeons2-compat/xauth.py
```

Python 3 and the `openssl` command must be available. The helper uses Python's standard library.

Back up and copy `src/xgameruntime.dll` to these three locations inside your bottle:

```text
C:\windows\system32\xgameruntime.dll
C:\Program Files (x86)\Steam\steamapps\common\Minecraft Dungeons II\xgameruntime.dll
C:\Program Files (x86)\Steam\steamapps\common\Minecraft Dungeons II\Dungeons\Binaries\Win64\xgameruntime.dll
```

Adjust the Steam location if your installation differs. In CrossOver's Wine Configuration, add `xgameruntime` under Libraries and select native first if needed.

Launch through Steam. The helper may open Microsoft's device-code sign-in page. Existing compatible credentials can be reused; older caches without a PlayFab token need renewal.

The helper writes its cache to `~/.local/share/dungeons2-compat/tokens.txt`. The DLL also checks `C:\users\steamuser\AppData\Local\Dungeons2\tokens.txt` first. If that bottle cache exists but is expired or lacks the PlayFab token, rename it as a backup so the renewed helper cache can be used.

The runtime writes diagnostics to `C:\xgr.log`. Inspect logs locally; they may contain sensitive signed URLs. Never publish token caches or unfiltered logs.

## Build

Install MinGW-w64, then run:

```sh
brew install mingw-w64
./build.sh
```

The prebuilt DLL is Windows x86-64. SHA-256:

```text
8d3545a9caf7e958085bfb95cfb5fa200c93e540b1094aa29a0eaeb3b0d6b609
```

## Credits and license

Original compatibility shim and account-linking work: [Kubas556/Dungeons2_linux_fix](https://github.com/Kubas556/Dungeons2_linux_fix).

CrossOver adaptation: [typester/Dungeons2_linux_fix](https://github.com/typester/Dungeons2_linux_fix), [upstream PR #5](https://github.com/Kubas556/Dungeons2_linux_fix/pull/5).

Distributed under the upstream MIT license; see [LICENSE](LICENSE).

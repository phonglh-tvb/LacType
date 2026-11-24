# LacType

LacType is a GPL-3.0 Vietnamese input method written in Rust for macOS and
Linux. It began as a ground-up rewrite of OpenKey and now has its own name,
icon, application bundle, and implementation.

## Features

- Pure Rust, stateful Telex and VNI engine
- Correct tone placement for common Vietnamese vowel groups
- Composition-aware Backspace
- User-defined text macros through the engine API
- Native global keyboard interception on macOS and Linux
- Linux support at the `evdev`/`uinput` layer, independent of X11 or Wayland
- Small command-line converter for testing and scripting

## Build

Install the stable Rust toolchain, then run:

```sh
cargo build --release
cargo test --workspace
```

The binary is written to `target/release/lactype`.

Build a signed local macOS application bundle:

```sh
./packaging/macos/build-app.sh
open dist/LacType.app
```

The local bundle uses ad-hoc signing for development. A public release should
use an Apple Developer ID certificate and notarization.

## Use

Verify Telex conversion without installing the keyboard daemon:

```sh
lactype convert telex 'Tooi ye ** Vieetj Nam'
```

Start the input daemon:

```sh
lactype daemon telex
# or
lactype daemon vni
```

### macOS permission

The daemon requests Accessibility permission when it starts. If needed, enable
the terminal or packaged LacType application in **System Settings -> Privacy &
Security -> Accessibility**, then restart LacType.

Check the current state with:

```sh
lactype permissions
```

### Linux permission

LacType reads keyboard devices from `/dev/input` and creates a virtual keyboard
through `/dev/uinput`. Grant those permissions with your distribution's
`input`/`uinput` group or a narrowly scoped udev rule; do not run the daemon as
root. Log out and back in after changing group membership.

## Security

The daemon necessarily sees keyboard events in order to implement an input
method. Events are processed in memory only. LacType does not log keystrokes,
write them to disk, or send them over the network. Capture failures are
fail-open so the physical keyboard remains usable.

## License and attribution

LacType remains licensed under GPL-3.0. The original OpenKey project was created by
Mai Vu Tuyen and contributors at <https://github.com/tuyenvm/OpenKey>.

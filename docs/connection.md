
# Connection Architecture

## Goal

Connect an iPhone to a Samsung Galaxy A12 over the internet without installing a permanent Android companion app.

## Initial Pairing

1. Enable Android Developer Options.
2. Enable Wireless Debugging.
3. Pair the device using Android's pairing code.
4. Save the device identity securely on iOS.

## Remote Connection

ADB must not be exposed directly to the public internet.

A secure network tunnel is required between the iPhone and Android device.

## Remote Commands

Supported operations to investigate:

- Capture Android screenshots.
- Send touch input.
- Send swipe input.
- Launch applications.
- Execute authorized shell commands.

## Security

- Pairing requires physical access and user approval.
- Authenticate every remote session.
- Encrypt network traffic.
- Never expose ADB ports publicly.

## Important Technical Note

An iPhone cannot use Android Wireless Debugging automatically.

A native ADB implementation or a compatible iOS networking component will be required.

Screen streaming and remote input must be tested against the target Android version.

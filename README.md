# SimpleScan

I needed a simple as fuck barcode scanner for [38C3](https://events.ccc.de/congress/2024/infos/index.html) and there was no apps that didn't want the wacky digits on the back of my credit card.
iOS has a built in framework for scanning barcodes, what am I paying for?.

The UI is basic af, probably just what you need. It exposes the performance option as a segmented control, but there doesn't seem to be any issue with the accuracy profile, I think this option more had text in mind. 

## Known Bugs
- The torch switch only has an effect when the profile is set to accurate. Under the hood this listens for `.AVCaptureSessionDidStartRunning` and enables the torch after. For whatever reason this isn't called with other profiles.

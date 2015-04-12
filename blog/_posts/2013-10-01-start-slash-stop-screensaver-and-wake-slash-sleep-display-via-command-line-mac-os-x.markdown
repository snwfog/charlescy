---
layout: post
title: "Start/Stop screensaver and wake/sleep display via Command Line (Mac OS X)"
date: 2013-10-01 21:21
comments: true
categories: [command, commandline, macosx, ssh]
---

I have a Mac Mini installed as a multimedia server in my room, attached to a small display that was hanging around, and I wish to put the display to sleep or start my beautiful screen saver via a quick ssh command since I’ve decided to not to attach a keyboard nor a mouse to the server.

To start the screensaver,

```
alias startss='open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'
```

To stop the screensaver,

```
alias stopss='killall -1 ScreenSaverEngine'
```

To wake the display,

```
alias wakedisplay='TIME="$(date -v +6S '+%m/%d/%Y %H:%M:%S')"; sudo pmset schedule wake $TIME'
```

To sleep the display,

  1.  Download [Sleep Display](https://www.macupdate.com/app/mac/26234/sleep-display)
  2.  Copy the binary file from the content to `/usr/local/bin`

Reference link:

  1. http://onethingwell.org/post/3504021412/pmset
  2. http://apple.stackexchange.com/questions/53802/waking-display-from-terminal-general-waking




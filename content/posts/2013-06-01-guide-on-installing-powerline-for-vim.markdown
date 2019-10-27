---
layout: post
title: "Guide on installing powerline for vim"
date: 2013-06-01 12:45
comments: true
categories: 
---
I decide to do some clean up for my vim profile since I've been using it extensively at work at the moment. I found [powerline](https://github.com/Lokaltog/powerline), an eye-candy status bar for vim, and MacVim. A lot of people runs into error while trying to install powerline, including myself. So here is a step by step guide of how I install powerline for myself. Keep in mind however that I take a lot of assumption that you are already familiar with working with the terminal on an unix machine. I am using Lion 10.8.3.

First, install python from `brew`
	
	$ brew install python

Easy enough. Make sure that now your system is using the appropriate python by doing a `which python` or `python --version`. It should be located in the `/usr/local/bin` directory which is where homebrew install the binary.

In case this fails, look through the homebrew installation output and if you find that homebrew is refusing to sym link python, it is probably because that it cannot write to `/usr/local`. So following [this](http://stackoverflow.com/questions/13088998/homebrew-python-installing) post on stackoverflow, yu should issue the following command to take over your `/usr/local` directory.   

	$ sudo chown -R `whoami` /usr/local
	$ brew link --overwrite python

After installing python, I suggest also a fresh installation of vim from homebrew as well.

	$ brew install vim --env-std --override-system-vim --enable-pythoninterp;

Install [janus](https://github.com/carlhuda/janus) the vim distribution. Janus will make a back up of your current vim setup, but I suggest you to back it up yourself as well just in case.

	$ curl -Lo- https://bit.ly/janus-bootstrap | bash

Create a `.janus` directory at your user root, and clone a copy of powerline inside of it.

	$ mkdir ~/.janus
	$ hub clone Lokaltog/powerline ~/.janus/powerline

Janus create two new file for your vim configuration, a `.vimrc.before` and a `.vimrc.after`. `.vimrc.before` is use for Janus setup, and `.vimrc.after` will contains your personal preferences.

	$ echo 'set rtp+=~/.janus/powerline/powerline/bindings/vim` >> ~/.vimrc.before
	$ echo 'set guifont=Inconsolata-dz\ for\ Powerline:h12'

Now last but not the least, the second command set the font that vim should use. As you can see, if you were to launch vim right now, you would see powerline status bar but with [x]'s because the glyphs are not showing properly. So we need to install powerline compatible fonts.

	$ hub clone Lokaltog/powerline-fonts ~/src/monofonts

Once the directory is clone, install the font with Font Book.

Now you should have an awesome looking vim status bar.
 

 

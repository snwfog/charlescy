---
layout: post
title: "Ruby + Octomars"
date: 2013-05-30 17:33
comments: true
categories: 
---
If you have trouble setting up MarsEdit and Octopress through [octomars](https://github.com/danimal/octomars). Try first remove rvm and use rbenv instead. I don't know why exactly, but it seems that the rbenv shim in the path works better than rvm's path. With `rvm` Octomars seems to be always using the `/usr/bin/ruby` instead of the `rvm` version.  
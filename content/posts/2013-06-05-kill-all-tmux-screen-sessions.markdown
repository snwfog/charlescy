---
layout: post
title: "Kill all tmux screen sessions"
date: 2013-06-05 20:11
comments: true
categories: 
---
I have been switching from `screen` to `tmux` lately. I immediately installed [tmuxinator](https://github.com/aziz/tmuxinator), a Ruby gem that allows you to manage your `tmux` session and project. It comes pretty handy. 

Although one thing has bothered me a lot with screen multiplexing such as `tmux` or `screen` is that sometime I run into where I have 4-5 sessions hanging around 'all over the place'. There isn't seems to have a command in `tmux` that allows you to clean every sessions. 

To remedy the situation, here is a short script that you can invoke and that will kill all your running `tmux` sessions.

```
tmux ls | awk '{print $1}' | sed 's/://g' | xargs -I{} tmux kill-session -t {}
```
You can put it into a nice little alias
```
alias kts='tx ls | awk '{print $1}' | sed 's/://g' | xargs -I{} tmux kill-session -t {}'
```

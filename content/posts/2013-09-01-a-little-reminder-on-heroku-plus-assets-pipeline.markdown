---
layout: post
title: "A little reminder on heroku + assets pipeline"
date: 2013-09-01 00:09
comments: true
categories: [rails, heroku, cloud]
---

I was trying to deploy a demo Rails app on Heroku today, and ran into problems with assets for not showing correctly. Taking a quick look at `heroku logs`, shows that the path for the assets with the fingerprinting is unreachable. The solution to this problem, without running a local `be rake assets:precompile`, is to modify the following line(s) in the `production.rb` file

```
config.assets.initialize_on_precompile = false ( < 4.0 )
config.assets.compile = true
```

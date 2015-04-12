---
layout: post
title: "git subtree tutorial"
date: 2013-08-17 17:41
comments: true
categories: [git, git subtree, subtree]
---

I recently had to write Redmine plugins at work. Redmine is a CMS web application built using the Ruby on Rails framework. I have a local development directory of Redmine. However, I do not want to version control everything in the Redmine folder, because I am only going to make changes in my plugins. I wanted the ability to export my plugins independently and be able to version track it with `git`, to have a separated commit logs and history and be able to extract the history into a standalone repository to push to Github. I wanted this flexibility at anytime during my development so that I can push my daily commits upstream and work on them later at home or elsewhere if needed.

I looked into `git submodule`, and I did not quite feel comfortable with the idea of keeping extra file to keep track of the submodules. The idea of running multiple commands just to pull from all the plugins’ remote did not catch me either.

After looking for solution on the Internet, I decided to use `git subtree`.

`git subtree` can construct *synthetic* branches from existing commits in my working directory. You don’t need to keep track of a submodule file, and you don’t need to run multiple `git` commands to push and pull from all of the existing remotes. `git subtree` works on only one history; the main project history. From this single history, `git subtree` can construct a new branches from commits that directly affect the target submodule directory. For instance, lets say my parent repository looked like this, as in my case it would be the Redmine project:

```
./redmine
├── app
│   ├── ...
├── config
│   ├── ...
├── db
├── plugins
│   ├── redmine_plugin_01
│   └── redmine_plugin_02
├── public
│   ├── ...
├── script
└── test
```

I spared a few regular Rails directories. The plugins are located under the **plugins** directory.

### Extracting local history
I will be using a submodule and subdirectory interchangeably, because a submodule is by default under its own subdirectory. So when I refer to a submodule, then I am also implicitly referring to the submodule’s directory. For a detail manual of `git subtree` you can consult it [here](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt).

To extract history of a submodule in the parent project, we can use the `split` command. A split command will take all the existing commits in your log, and construct a series of new commits (with new SHAs). These new commits will only be those who contain modification to your submodules. To split all commits made to `redmine_plugin_01`, run the command

```
git subtree split --prefix=plugins/redmine_plugin_01

...
-n 39/      45 (38)
-n 40/      45 (39)
-n 41/      45 (40)
-n 42/      45 (41)
-n 43/      45 (42)
-n 44/      45 (43)
-n 45/      45 (44)
b43265bbf0d7da20648ddc4e7ad30c96d978c0d4
```

You will notice that `git` will spit out bunch of info, but you will not notice any new commits. This is because there are nothing that refers to these commits (like a link list without a reference to a head). So to obtain a reference to these commits, use the `--branch, -b` option.

```
...
-n 42/      45 (41)
-n 43/      45 (42)
-n 44/      45 (43)
-n 45/      45 (44)
Created branch ‘redmine_plugin_01’
b43265bbf0d7da20648ddc4e7ad30c96d978c0d4
```

Now you see that `subtree` after splitting, will also create a new branch for us to reference to these new commits. In the `subtree` documentation, this tree is referred as a new **synthetic** tree/commits. Because these tree, although they contains new commits SHA, they do not contain any new content.

Now if we run `git branch`

```
* master
  redmine_plugin_01
```

We see that this branch exists. But where does it exists? To understand better this new tree, we need to take a look at the graphical `git`.


In this screenshot, we see that the new branch `redmine_plugin_01`, is completely detached from the main project’s branch. I don’t know what they are called exactly, but I refer them as **hanging**, or **detached** branches, because they are not attached to the main history.

There are a few more options that we can apply when we do the split command. The `--annotate` option will prepend a new string to every commit message in the new commits. Because these commits will essentially have the exact same commit message, but different in the SHA.


Now we can manipulate this new branch to get it ready to push to its new repository. Assume for the moment that this repository is completely empty.

The squash command comes with `subtree add merge pull push`, but not with `split`. We could do an interactive rebase on this new branch to squash all of the commit.

First checkout this new branch, `git checkout redmine_plugin_01`, then do `git rebase -i --root`. Rewrite your history like a regular interactive rebase.


The `--rejoin` command allow you to merge the new splitted branch immediately back into your main project. I have not figure out the reason why I would want to do that, but here is how.

```
git subtree split --prefix=plugin/redmine_plugin_01 \
--branch=redmine_plugin_01 --annotate='(plugin 01 split)' \
--rejoin master
```

### Updating submodules repository

Now here is a common problem that I see people are having on StackOverflow. After making modifications to a subproject, you wish to push these new changes to the remote repository of the subproject. A lot of people are running to rejected push. To fix this problem, cleanly, you need to use the `split` command with `--onto` specified. And here is how.

If you have splitted commits with `subtree` previously, then you must have a **hanging** branch in your repository. This branch, like I have said it before, is the result of a `subtree split`. In order to succesfully update the remote repository, you need to put the new commits on top of the **hanging** branch. To do that, simply do

```
git subtree split --prefix=plugins/redmine_plugin_01 \
--onto redmine_plugin_01 --branch redmine_plugin_01
```

This essentially says, make a new synthetic history of my commits starting from where `--onto` is specified, then, make a new branch called `redmine_plugin_01`. This will add all the new commits on top of the previous `redmine_plugin_01`. Then you can do a `git push` to the submodule remote repository to update it.

```
git push -f https://github.com/snwfog/redmine_plugin_01 \
redmine_plugin_01:master
```

This says to push my local branch `redmine_plugin_01` to the specified remote, at the branch of `master`. The `--force` option make sure that the remote will accept the local history.

### Conclusion
I hope this will help with `git subtree` workflow. For more information about `git subtree`, I really suggest reading through the [manual page](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt). Personally, what I would like to learn more about is how to cleanly apply merges from an updated remote, bring it into the local repository, and then split new commits from there. Maybe I will investigate this issue in another blog.
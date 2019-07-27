To setup mercurial remote in git

See https://github.com/felipec/git-remote-hg

* Download https://raw.github.com/felipec/git-remote-hg/master/git-remote-hg
  and put it in your $PATH
* Setup the scintilla upstream repo

```
    git remote add upstream hg::http://hg.code.sf.net/p/scintilla/code
```
* To pull in latest code from sourceforge

```
    git pull --tags upstream master
    git push --tags origin master
```


# Silent Make Rules

GNU Make is an amazing tool but by default it is a bit verbose.

Here's a simple exmaple makefile which creates a small static HTML page from a
few snippets of various bits of content.

```
Makefile
.PHONY: all
all: site1.html

%.html: header.snip footer.snip js-%/* css-%/* html-%/*
        cat header.snip > $@
        cat $(filter css-%,$^) >> $@
        cat $(filter html-%,$^) >> $@
        cat $(filter js-%,$^) >> $@
        cat footer.snip >> $@

.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += -rR
```

Now this works great. It only rebuilds the static page when any of the pieces
has changed, etc. It does what we need (it could be improved some to keep
pre-concatenated pieces of the css, js and html bits so we don't need to read
all those files each time but that's a different story) but let's look at
**how** it does what we told it to do.

```
$ ls -1
Makefile
css-site1
footer.snip
header.snip
html-site1
js-site1
$ make
cat header.snip > site1.html
cat css-site1/article.css css-site1/navbar.css css-site1/snippet.css >>
site1.html
cat html-site1/body.html html-site1/navbar.html html-site1/rss.html
html-site1/talkinghead.html >> site1.html
cat js-site1/ads.js js-site1/breadcrumb.js js-site1/navbar.js
js-site1/talkinghead.js >> site1.html
cat footer.snip >> site1.html
$ ls -1
Makefile
css-site1
footer.snip
header.snip
html-site1
js-site1
site1.html
$
```

So it clearly worked without too much fuss but is also told us **way** too much
about what it was doing. We don't care about all those details most of the
time.

Now you can silence make entirely with the `-s` flag.

```
$ rm site1.html
$ make -s
$
```

But that makes make a bit **too** terse.

You can silence individual rules with the `@` prefix on the recipe line.

```
$ rm site1.html
$ cat Makefile
.PHONY: all
all: site1.html

%.html: header.snip footer.snip js-%/* css-%/* html-%/*
        cat header.snip > $@
        @cat $(filter css-%,$^) >> $@
        @cat $(filter html-%,$^) >> $@
        @cat $(filter js-%,$^) >> $@
        cat footer.snip >> $@

.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += -rR
$ make
cat header.snip > site1.html
cat footer.snip >> site1.html
$
```

That's better (we ignored the body content lines and only left the start and
end lines. But that's still more information then we actually care about (and
picking which lines are the most meaningful to show isn't always clear).

The people behind the autotools came up with a very clever solution/hack to
this problem. This project is my implementation of the same idea without the
rest of the autotooling.

Using this `Makefile`:

```
$ cat Makefile
include silent_rules.mk

.PHONY: all
all: site1.html

%.html: header.snip footer.snip js-%/* css-%/* html-%/*
        $(SR_V_GEN)cat header.snip > $@
        $(SR_V_AT)cat $(filter css-%,$^) >> $@
        $(SR_V_AT)cat $(filter html-%,$^) >> $@
        $(SR_V_AT)cat $(filter js-%,$^) >> $@
        $(SR_V_AT)cat footer.snip >> $@

.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += -rR
```

We get this output:

```
$ rm site1.html
$ make
GEN site1.html
$
```

Now that's **much** nicer. We get a clean message telling us what make did without
any extraneous information.

But what if we **do** want to know what make is doing?

```
$ rm site1.html
$ make V=1
cat header.snip > site1.html
cat css-site1/article.css css-site1/navbar.css css-site1/snippet.css >>
site1.html
cat html-site1/body.html html-site1/navbar.html html-site1/rss.html
html-site1/talkinghead.html >> site1.html
cat js-site1/ads.js js-site1/breadcrumb.js js-site1/navbar.js
js-site1/talkinghead.js >> site1.html
cat footer.snip >> site1.html
$
```

Or we don't even want that small amount of output?

```
$ rm site1.html
$ make V=-1
$
```

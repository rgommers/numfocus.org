numfocus.org
============

NumFOCUS Website

This is the source of the pelican-based NumFOCUS.org site.  These pages should
be generated from these sources and then pushed to the actual site.

The site is based on Pelican:  http://docs.getpelican.com/en/3.2/


Workflow
========
To add/modify content to the website, please fork the numfocus/numfocus.org
repository on github and make your changes as described below.  When your
changes are ready, please submit a pull request (PR) to have those changes
merged in.  Please apply all changes via PRs.  It makes is much easier for
others to follow changes.  Finally, if you merge a PR, you are responsible for
deploying it or delegating that task in the PR discussion.


Adding Content
==============
The site is organized as a blog with a set of post categories.  Each post
categorized post will show up in the news feed as well as in its designated
category.  To add new content, create a .rst file in the appropriate category
directory in content.  For example, to add the minutes from the most recent
board meeting, you should add a file to the "Board Meetings" directory.  Posts
should provide a title and a date i.e

    inSCIght
    ########
    :date: 07-05-2013

Posts can optionally provide a `:slug:` field.  The slug is used to generate a
direct link to the post.  If no slug is provided, the title ("inSCIght" in the
above example) will be used.


Adding Images
=============

Images should be added to the with `content/images` directory.  If the filename is
`spam.jpg`, the path image path in RST is: `|filename|/images/spam.jpg`  The funny
`|filename|` syntax is how Pelican manages internal links.  The `content` directory
forms the root for paths.


Building and deploying the Site
===============================

Python Dependencies
-------------------
Note that you have to have the following packages installed for everything to
work properly (see requirements.txt):

* python 2.7 (might work with others, no promises)
* pelican
* typogrify
* ghp-import

Non-Python dependencies
-----------------------
* Make
* sass-lang
    $ gem install sass
    $ sass -v
    Sass 3.3.8 (Maptastic Maple)     

Building
--------

Use the following to build the and serve the site locally:

    make html 
    make serve

To edit content and have the local repo update continually, you can use the dev server. Just remember to shut it down later.

    make devserver
    make stopserver

Use the following to push the results up to github:

    make github

For this to work, please set your github remote 'upstream' to 
'git@github.com:numfocus/numfocus.org.git'.

For more targets (such as debug to find errors) run:

    make help


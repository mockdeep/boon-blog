---
title: React DnD Example Simplified
date: 2015-04-13
tags: technical, react
authors: Robert Fletcher
disqus_title: React DnD Example Simplified
disqus_identifier: 2015-04-13-react-dnd-example-simplified
disqus_url: http://blog.boon.gl/2015/04/13/react-dnd-example-simplified
---

I recently started playing around with [React DnD][react-dnd] to implement some
drag and drop sorting on [an app I'm working on][questlog]. The [examples
provided][dnd-examples] are built using a lot of the new syntax in ES6, as well
as having a good deal of what might be considered more "proper" structuring for
a React app, so it was challenging for me to parse out the critical bits for
React DnD to function. To further my own understanding, I stripped out all of
the ES6 syntax and some of the non-essential code in order to get the most
basic drag and drop implementation up and running. READMORE Check it out below,
as well as the [original example][dnd-original-example] for reference. This
was built in the context of a rails app with [react-rails][react-rails] and
[rails-assets][rails-assets]-react-dnd, though I think the code should work
readily outside of the rails context.

<script src="https://gist.github.com/mockdeep/2cb109097a9f9580aeb5.js"></script>

[react-dnd]: https://github.com/gaearon/react-dnd
[questlog]: https://www.questlog.io
[dnd-examples]: https://github.com/gaearon/react-dnd/tree/master/examples
[dnd-original-example]: https://github.com/gaearon/react-dnd/tree/master/examples/_sortable-simple
[react-rails]: https://github.com/reactjs/react-rails
[rails-assets]: https://rails-assets.org/

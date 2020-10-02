---
title: Setting up a Middleman Blog
date: 2014-09-23
tags: technical, blogging, middleman
authors: Robert Fletcher
disqus_title: Setting up a Middleman Blog
disqus_identifier: 2014-09-23-setting-up-a-middleman-blog.html
disqus_url: http://blog.boon.gl/2014/09/23/setting-up-a-middleman-blog.html
---

Second blog post seems like a good time to write about my experience setting up
a blog using [Middleman][middleman] while it's still fresh in my mind.
Middleman is a static site generator, a la [Jekyll][jekyll], and I'm using
their [blogging extension][middleman-blog]. If you're starting fresh, then I
would recommend the [thoughtbot post][thoughtbot] on how to get a blog set up
with their [bourbon][bourbon], [neat][neat], and [bitters][bitters] SASS
libraries, as this is somewhat an extension of their post. I'll talk about
setting up layouts, as well as coping with some minor styling issues I ran
into.

READMORE

## The Issue

So coming away from the above thoughtbot blog post, I was pretty happy with the default styling
provided by bitters, but one particular issue was that it removes the bullets and numbers
from ordered and unordered lists. This makes sense in terms of the navigation, but
inside my blog post I actually wanted to see them. Without putting straight up
html in my markdown, my options for customizing the styling were limited. I
spent probably well more time than I ought to have finagling the styling and
structuring in my layout file only to find that the styling would work on the
index page but not in the article view, or vice versa. Thus I went on the hunt
for a saner option and found it in [nested layouts][nested-layouts].

## Nested Layouts

Setting up nested layouts is pretty straightforward. Here's one of those lovely
bullet point lists:

- create an `articles` directory and move your blog posts in there
- create a `layouts` directory for your nested layouts
- add a layout `layouts/article_layout.html.erb`
- add the following configurations to `config.rb`
  - `blog.sources = 'articles/{year}-{month}-{day}-{title}.html'`
  - `page '/articles/*', layout: :article_layout`

And you should be set. Here's what my article layout looks like:

```erb
<% wrap_layout :layout do %>
  <h3><%= link_to current_article.title, current_article %></h3>
  <h5><%= current_article.date.strftime('%b %d, %Y') %></h5>
  <article>
    <%= yield %>
  </article>
<% end %>
```

and my config.rb, minus the fluff:

```rb
activate :blog do |blog|
  blog.sources = 'articles/{year}-{month}-{day}-{title}.html'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

activate :syntax, line_numbers: true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true

page '/feed.xml', layout: false
page '/articles/*', layout: :article_layout

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :build_dir, 'tmp'

configure :build do
end

configure :development do
  activate :livereload
end
```

## Styles

So there were a couple of styling issues I ran into. The first was the
aforementioned missing bullets. I created a new partial
`stylesheets/partials/_article.css.scss`:

```scss
article {
  ul {
    @extend %default-ul;
  }

  ol {
    li {
      margin: 0;
    }
    @extend %default-ol;
  }
}
```

**You'll need to add `@import 'partials/article';` to `all.css.scss` after the
bourbon includes.**

One other issue is that the default bourbon styling on tables makes the line
numbers in fenced code blocks take up half the page, so I also added this to
`_article.css.scss`:

```scss
article {
  // ...other stuff you just added

  .highlight {
    table {
      width: auto;
    }
  }
}
```

And that just about covers it.

## Errors

Here are a couple of errors and bugs I ran into, so if you see them, here's how
you can fix them. If you run into a build error, use `middleman build
--verbose` to get the full output.

#### undefined method `title' for nil:NilClass

You probably haven't put your layout in it's proper subdirectory. Move
`article_layout.html.erb` into the `layouts` directory.

#### article not showing up

Make sure your article is in the `articles` subdirectory, and make sure you
don't have

```yml
published: false
```

in your front matter at the beginning of the post.

#### The selector "%default-ul" was not found.

It's trying to precompile your `scss` partial stand alone. Double check that you
have the `_` in `_article.css.scss`.

## Fin

That's all. You can check out the full repo [here][blog-repo], and the build
that was referenced in this blog post [here][blog-tag].

[middleman]: http://middlemanapp.com/
[jekyll]: http://jekyllrb.com/
[middleman-blog]: http://middlemanapp.com/basics/blogging/
[thoughtbot]: http://robots.thoughtbot.com/middleman-bourbon-walkthrough
[bourbon]: http://bourbon.io/
[neat]: http://neat.bourbon.io/
[bitters]: http://bitters.bourbon.io/
[nested-layouts]: http://middlemanapp.com/basics/templates/#nested-layouts
[blog-repo]: https://github.com/mockdeep/boon-blog
[blog-tag]: https://github.com/mockdeep/boon-blog/tree/bourbon-blog

---
title: Routes as State in React
date: 2017-06-29
tags: technical, react, redux
authors: Robert Fletcher
disqus_title: Routes as State in React
disqus_identifier: 2017-06-29-routes-as-state-in-react.md
disqus_url: http://blog.boon.gl/2017/06/29/routes-as-state-in-react.md
---

I've been using [React Router][react-router] for a while now in a project and
was running up against some frustration getting access to information that
comes through the URL. I'm using [Redux][redux] and [React Redux][react-redux]
for state management and [Reselect][reselect] for getting useful bits of
information out of the state. The problem is that when I need to grab some
information from the state based on the current route, it can be really tricky
to get all of the information I need in the right places. After a good deal of
head scratching and soul searching, I realized that for my purposes, the
routing information belongs in the state, not encoded implicitly in the
components that are rendered.

READMORE

## The Lay of the Land

So I'm working on yet another todo list application. By default it shows you
the next ordered task from your list, one at a time. When you select a tag, it
should update the URL based on a url friendly "slug" for that tag (e.g.:
`/at-home`), as well as showing the next task for that specific tag.  Starting
out, for this workflow, I was using React Router's `Link` component and had a
simple `onClick` handler that set the selected tag in the redux store:

```jsx
function TagLink(props) {
  const { updateTagMeta, slug, name, id } = props;

  return (
    <Link to={`/${slug}`} onClick={() => updateTagMeta({ selectedTagId: id })}>
      {name}
    </Link>
  );
}
```

Routes looked something like:

```jsx
<Provider store={appStore}>
  <BrowserRouter>
    <Switch>
      <Route exact path='/' component={TaskContainer} />
      <Route path='/sessions/new' component={SessionsNew} />
      <Route path='/tasks' component={TaskList} />
      <Route path='/:slug' component={TaskContainer} />
    </Switch>
  </BrowserRouter>
</Provider>
```

This all worked well and fine, as long as the user got to a tag by clicking on
it. However, if the user used the URL to navigate to a tag (e.g.: by visiting
`/at-home`) things didn't work. There was no `selectedTagId` in the store so it
ended up showing the next task from all of them. I had to find a way to get the
currently selected tag into the state from the get go. When a user clicked the
button, I set the selected tag id and also the slug in the URL, but when they
went directly to that URL, I needed a way to derive the tag id from the slug
already in the URL.

I considered a few options here. The first was to find a way to make use of the
slug that was being parsed out by the `Route` component. It passed the matched
URL elements down to the sub-components, so I could have added some lifecycle
hooks to check for an updated slug and update the store accordingly. This
didn't feel quite right to me, though. I don't like my components being too
smart, and in this case it felt weird to have my sub-components doing the work
of compensating for missing state that really ought to already be in the store.
I briefly looked at [React Router Redux][react-router-redux], but the only
thing it provides you is the entire route path, not the matched elements from
the path, so with or without it, I'm left with the option of parsing the path
myself, duplicating the work that is already being handled by the `Route`
component. I could have written my own wrapper component, but when I am
starting to write as much code to work around a library as it would take to
roll my own, I start to think it's time to build something more specific to my
needs.

## My Approach

In addition to the issue above, I've also had another nagging concern. I don't
like how tightly coupled the logic in my app is tied to the path in the URL.
Much like one would fetch and persist data to a server, but store it locally
in, say, a Redux store, it seems to me like we ought to do an initial "fetch"
of the data from the URL, normalize it in a reasonable format for our client
side, and hold onto it in our store. Likewise, when we update the information,
we "persist" it to the URL, but continue to use our store as the source of data
for our components. With all of this in mind, here's what I came up with.

#### Routes

```js
import pathToRegexp from 'path-to-regexp';

function compileRoutes(routes) {
  return routes.map((route) => {
    const regexp = pathToRegexp(route.path);

    return {
      ...route,

      match(path) {
        const result = regexp.exec(path);

        if (!result) { return null; }

        const params = {};

        regexp.keys.forEach((key, index) => {
          params[key.name] = result[index + 1];
        });

        return params;
      },

      toPath: pathToRegexp.compile(route.path),
    };
  });
}

const ROUTES = compileRoutes([
  {name: 'root', path: '/'},
  {name: 'sessionsNew', path: '/sessions/new'},
  {name: 'tasks', path: '/tasks'},
  {name: 'tag', path: '/:slug'},
]);

export default ROUTES;
```

#### Reducer

```js
import ROUTES from 'src/route/routes';

export default function routeReducer(previousState, action) {
  if (action.type === 'route/SET') {
    const {name, ...params} = action.payload;
    const matchingRoute = ROUTES.find((route) => route.name === name);

    window.history.pushState(null, null, matchingRoute.toPath(params));

    return {name, params};
  } else if (action.type === 'route/INIT') {
    let params;

    const matchingRoute = ROUTES.find((route) => {
      params = route.match(window.location.pathname);

      return Boolean(params);
    });

    return {name: matchingRoute.name, params};
  }
};
```

#### Router Container

```js
import {connect} from 'react-redux';

import Router from 'src/route/components/router';

function mapStateToProps(state) {
  return {route: state.route};
}

export default connect(mapStateToProps)(Router);
```

#### Router Component

```jsx
import React from 'react';

import SessionsNew from 'src/session/components/new';
import TaskContainer from 'src/task/containers/item';
import TaskList from 'src/task/containers/list';

const ROUTE_NAME_TO_COMPONENT_MAP = {
  root: TaskContainer,
  sessionsNew: SessionsNew,
  tasks: TaskList,
  tag: TaskContainer,
};

export default function Router(props) {
  const Component = ROUTE_NAME_TO_COMPONENT_MAP[props.route.name];

  return <Component />;
};
```

#### Link Container

```js
import {connect} from 'react-redux';

import Link from 'src/_common/components/link';
import {setRoute} from 'src/route/action_creators';

export default connect(null, {setRoute})(Link);
```

#### Link Component

```jsx
import React from 'react';

import ROUTES from 'src/route/routes';

export default class Link extends React.Component {
  constructor(props) {
    super(props);
    this.navigate = this.navigate.bind(this);
  }

  navigate(event) {
    event.preventDefault();

    this.props.setRoute({name: this.props.to, ...this.props.params});
  }

  path() {
    const matchingRoute = ROUTES.find((route) => route.name === this.props.to);

    return matchingRoute.toPath(this.props.params);
  }

  render() {
    const {className, children} = this.props;

    return (
      <a href={this.path()} className={className} onClick={this.navigate}>
        {children}
      </a>
    );
  }
};
```

And the Tag Link from before becomes...

```jsx
function TagLink(props) {
  const { slug, name } = props;

  return (
    <Link to='tag' params={{slug}}>
      {name}
    </Link>
  );
}
```

## Epilogue

Et voila! The routing state is now in the store and accessible wherever we might
need a bit of info about what is going on. I've also made it so that the routes
are named. Some additional considerations:

- A careful reader will notice that my reducer is no longer "pure" in that it
  has a side effect on the URL. This was again for the sake of readability, but
  I'll probably end up moving that to an action creator.
- I'm not accounting for the user pressing the back button, but that should be
  manageable if we subscribe to history `POP` events and simply reset the
  routing state from scratch.
- I left off some additional error checking as an exercise for the reader (and
  again for readability), such as catching situations where a route does not
  exist and when the wrong parameters are passed for a route.
- I started writing this article and came across [this recent article from Free
  Code Camp][redux-first-routing] exploring similar ideas, though they take a
  middleware approach to updating the browser history. Might be worth a glance
  if you're looking for some alternatives. (And they've got more links for you
  at the end if you're still not satiated!)

[react-redux]: https://github.com/reactjs/react-redux
[react-router]: https://github.com/ReactTraining/react-router
[react-router-redux]: https://github.com/ReactTraining/react-router/blob/master/packages/react-router-redux
[redux]: http://redux.js.org/
[redux-first-routing]: https://medium.freecodecamp.org/an-introduction-to-the-redux-first-routing-model-98926ebf53cb
[reselect]: https://github.com/reactjs/reselect

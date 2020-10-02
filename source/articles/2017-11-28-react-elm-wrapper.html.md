---
title: React Elm Wrapper
date: 2017-11-28
tags: technical, react, elm
authors: Robert Fletcher
disqus_title: React Elm Wrapper
disqus_identifier: 2017-11-28-react-elm-wrapper.md
disqus_url: http://blog.boon.gl/2017/06/29/react-elm-wrapper.md
---

I've recently been spending a lot of time scratching my head regarding
application architecture with React and Redux. It often feels like this tug of
war between class based and functional programming. I'm not super attached to
one paradigm or another, but I am certainly FP-curious. However, whenever I
push to work exclusively in a functional way in JavaScript, I keep running into
situations where the code would be cleaner or more performant if I were doing
it in a mutative or class based way. It feels like I'm trying to awkwardly
shoehorn functional methods into a language that really wasn't built for it.

READMORE

## Enter Elm

I've been hearing more and more about this language [Elm][elm] and how happy
people are on that side of the fence, so I decided it's finally time to give it
a shot. It'll be a good opportunity to really immerse myself in functional
programming, and even if I come away feeling it's not for me, I should
hopefully come back with some new wisdom and appreciation for the React
ecosystem.

## In React?

The first step along that route is figuring out whether and how Elm might
actually integrate with React for an easier transition. It turns out it does,
and the core maintainers of Elm [built out a simple
harness][react-elm-components] to make it easier.  However, sadly, it hasn't
been updated in a while, so it doesn't work with React version 16. There's not
that much code to it, so I'd be hesitant to add it as a dependency, anyway. So
I brought the code up to date and plugged it into my application. Worked like a
charm. Here's the code:

```jsx
import autobind from 'class-autobind';
import PropTypes from 'prop-types';
import React from 'react';

class ReactElmWrapper extends React.Component {
  constructor(props) {
    super(props);
    autobind(this);
  }

  componentDidMount() {
    const app = this.props.src.embed(this.node, this.props.flags);

    if (this.props.ports) { this.props.ports(app.ports); }
  }

  shouldComponentUpdate() {
    return false;
  }

  storeNode(node) {
    this.node = node;
  }

  render() {
    return <div ref={this.storeNode} />;
  }
}

ReactElmWrapper.propTypes = {
  flags: PropTypes.object,
  ports: PropTypes.func,
  src: PropTypes.object.isRequired,
};

export default ReactElmWrapper;
```

and you can use it like:

```jsx
function MyReactComponent() {
  return <ReactElmWrapper src={SomeImportedElmApp} />;
}
```

See the "ground up" article below for a more in-depth example.

## Links

I've found these to be really helpful, or hope to find them helpful in the near
future:

- [Using Elm in React — from the ground up][ground-up]: This is a good place to
  start for setting up Elm with your application with configuration and a
  simple example project. Side note: if you're running Rails, you can just run
  `rails webpacker:install:elm` to get things configured.
- [Elm SPA Example][elm-spa-example]: A fully fleshed out Elm app with lots of
  great reference from nuts and bolts all the way up to application
  architecture.
- [Building A React/Redux/Elm Bridge][react-redux-elm-bridge]:
  Haven't dug into this one, yet, but looks like it'll provide some solid
  insights around passing data back and forth.
- [Node Elm Compiler][node-elm-compiler]: Haven't done anything with this, yet,
  but my JS tests are written in Jest, and I'd like them to continue working as
  I transition, so I think the code here may be useful along with [Jest's
  `transform` setting][transform]. If all goes well you'll be seeing another
  blog post soon about how I managed with that.


[react-redux-elm-bridge]: https://medium.com/javascript-inside/building-a-react-redux-elm-bridge-8f5b875a9b76
[elm-spa-example]: https://github.com/rtfeldman/elm-spa-example
[elm]: http://elm-lang.org/
[ground-up]: https://codeburst.io/using-elm-in-react-from-the-ground-up-e3866bb0369d
[node-elm-compiler]: https://github.com/rtfeldman/node-elm-compiler
[react-elm-components]: https://github.com/evancz/react-elm-components
[transform]: https://facebook.github.io/jest/docs/en/configuration.html#transform-object-string-string

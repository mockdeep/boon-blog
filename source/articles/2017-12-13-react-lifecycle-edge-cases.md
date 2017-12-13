---
title: React Lifecycle Edge Cases
date: 2017-12-13
tags: technical, react, redux
authors: Robert Fletcher
disqus_title: React Lifecycle Edge Cases
disqus_identifier: 2017-12-13-react-lifecycle-edge-cases
disqus_url: https://blog.boon.gl/2017/12/13/react-lifecycle-edge-cases.html
---

I have a "scratch" wrapper I wrote for React as an alternative to `setState`
for controlled components. The idea being that it's nice to keep all data in
Redux, but it's kind of a pain in the butt to do so manually for every single
form, since generally you will also want that data to be cleared from the store
when the form is unmounted. My `ConnectWithScratch` higher order component adds
lifecycle hooks on component mount and unmount to create and delete scratch
space for the component. As I've been using it, though, I've been discovering
some interesting edge cases that.

READMORE

So my current `ConnectWithScratch` component calls `createScratch` in
`constructor` with a user provided `scratchKey`. (I'm not going to share the
current implementation with you because it's a hairball and I'm still finding
edge cases.) It passes an `updateScratch` prop down to the component to use.
And it calls `deleteScratch` when the component unmounts. In one case I'm using
my scratch component for an edit task form, where the scratch key might be
something like `editTask-114`, where `114` is the task id. When I introduced
this edit task form on another page, I ran into an interesting issue. The one
one the new page has the same key, but when navigating from one page to the
other, it tries to create the scratch for the new page before the old one has
been removed. Console logging out revealed the following:

```
ShowView constructor // the new view is being rendered
ConnectWithScratch constructor:  editTask-114 // new view setting up scratch
creating scratch:  editTask-114 // so far so good...
FocusView componentWillUnmount // and the old view is about to unmount
ConnectWithScratch componentWillUnmount:  editTask-114 // old component scratch unmounting
deleting scratch:  editTask-114 // old component deletes the scratch space!!!
ConnectWithScratch componentDidMount:  editTask-114 // show view scratch mounted
ShowView componentDidMount // and the show view mounts, but has no scratch to work with
```

So, in short, React starts constructing the next component before the previous
one is told it will be unmounted. Which maybe makes sense in terms of how React
needs to work to reconcile and see if it can re-use anything. But it creates a
pain point here. A few options that come to mind for me:

1) I might be able to move the `createScratch` call to `componentDidMount`.
  This will cause extra renders and maybe performance issues, [per their
  docs][component-did-mount], but the user won't see any intermediary state. It
  also means we can't touch the scratch space in the constructor.

2) I could assign each scratch component a unique id instead and use that as
  the scratch key, or part of it. This loses some of the benefit of the scratch
  space, though, in that we no longer have a readable key for debugging, nor
  can we rehydrate components in a straightforward way.

3) I could require the parent component to pass down a part of the scratch key
  that would make it unique, such as `ShowView-editTask-114`,
  `FocusView-editTask-114`. This maintains readability and rehydratability
  (sic), but adds additional complexity to actually using the scratch
  container. Now both the parent and the child need to know about the scratch
  component.

I don't love any of these options, though I'm leaning towards option 1 for my
first attempt at a fix. Option 2 is my last resort.

[component-did-mount]: https://reactjs.org/docs/react-component.html#componentdidmount

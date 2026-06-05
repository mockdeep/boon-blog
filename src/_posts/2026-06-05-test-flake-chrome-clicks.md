---
layout: post
title: "Test Flake: Chrome Clicks"
date: 2026-06-05
tags:
- technical
- flake
authors: Robert Fletcher
---

This is the first in what I expect to be an ongoing series of posts on common
sources of test flake. Today: Chrome! Specifically, sometimes clicking a link
in end-to-end tests, even on a static page, doesn't navigate to the next page.
In the screenshot grabbed from the failing test it might even show the link as
outlined as if it *had* been clicked. There was a period where roughly half of
our builds were failing due to this issue, which, as you might imagine, can
make you start questioning the value of end-to-end tests.

<!--more-->

## The Diagnosis

My understanding is that Chromedriver figures out where the element is, then
clicks at those coordinates. If the layout shifts in that window, the click can
land in the wrong spot. My best guess at what we saw: the `mousedown` landed on
the link, focusing it, but by the `mouseup` the link had moved, so the two
never registered as a real click. Chromedriver has a [page on click
issues][cd], but it doesn't seem to be a priority for them to fix.

## The Fix

Switch to Firefox with Geckodriver. Maybe a bit cheeky, but that was our
solution, and the amount of flake in our end-to-end tests plummeted. You might
also consider checking out [Cuprite][cu] if you're in Ruby land, as it doesn't
use Chromedriver. There are a number of hackier alternatives, such as retrying
the click or doing a JavaScript `click()` directly on the element, but I'd be
concerned about those masking other issues.

[cd]: https://developer.chrome.com/docs/chromedriver/help/clicking-issues#chromedriver_cant_click_a_moving_element
[cu]: https://github.com/rubycdp/cuprite

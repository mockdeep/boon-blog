---
title: Who Belongs in Tech
date: 2016-12-02
tags: tech
authors: Robert Fletcher
---

I finished reading [this blog][saron-post] post by Saron Yitbarek and I had so
many things I wanted to say that I decided to write it up in a post of my own.
You will probably want to check hers out so that you know what I am responding
to here. As a disclaimer, I do my best to respond to what she is
saying, but a lot of this is just stuff I like to say, so might be
tangential... READMORE

First off, in commiseration
---------------------------

I have been through a lot of the same frustrations across my various jobs as an
engineer, and even similarly in my previous career as an architect. I take an
incredible amount of pride and pleasure in producing high quality, well
polished work. To a fault, in a way, as for me the polish often comes before
any concern for the actual product that I am building. I tend to be more
interested in whether I solved the problem well, rather than whether the
problem was even worth solving.

The thing that many people don't understand is that these things are not in
conflict. Code quality is not in conflict with getting things out the door.
I'll get something finished well tested and polished just as quickly, if not
moreso, than you will something messy and rushed. And I'll be able to quickly
iterate on it while you're tripping over the hacks you put in place to avoid
spending an extra few minutes thinking what the right way to do something is.
Testing is just not that much work, and hacking comes back to haunt you sooner
than you think—within weeks, or even a couple of days. You keep tripping over
it again and again, and have to remember "Oh, yeah, that thing is there."
Building software is something that is structurally very different than other
areas of business. The closest analogy I have been able to come up with is that
it is like trying to build [The Burrow][the-burrow]—without magic. You are
constantly building more and more on top of existing structures, so the more
solidly the lower levels are reinforced, the safer you will be as you go along.

While people might logically understand these things, they are not going to
fully integrate it unless they can viscerally *feel* it. I have had contracting
gigs that have lasted only a couple of hours because I thought it was important
to have working tests and the project owner disagreed. I have been with [our
current company][chalk] since the very early stages more than four years ago.
Near the beginning, our CTO and I would get into angry arguments about code
quality and testing. Because of my experience and the value I provided, I was
able to push it and get our test coverage up to 100%, where it has more or less
stayed since. Now there is no one on our team who will advocate more
vociferously than her for testing and doing things the right way, since now she
can get a good night's rest instead of burning the candle at both ends the way
she was before, up responding to late night phone calls and fixing errors in
production.

Here's the "but"
----------------

Wanting to understand a problem thoroughly can be a really beneficial
attribute, but it can also be a hindrance. Software engineering, like
democracy, is messy. You will hear me use the phrase "the right way" a lot, but
the truth is, there is no one, unambiguous "right way". There is always some
ambiguity to be dealt with. There are a lot of times no amount of turning a
problem over in your head is going to help you understand it as thoroughly as
you might want. Sometimes getting something deployed is the most effective way
to understand it. A lot of times we don't know what the best solution to a
problem is, so we build it the best we know how and look back on it later with
clearer eyes, either with feedback from customers, or from ourselves as
engineers having to deal with the consequences of a particular coding decision.
One of the things you will hear on our team over and over again is "but we can
change it later". It is not meant to be an excuse for sloppy work, but an
admission that while we spent some time thinking about it, we were not able to
come up with an optimal approach, so we settled on this for now. (It's also a
great way of handling disagreement, since no decision has to be final.) You
should, of course, never deploy anything that puts your users at risk.

We keep learning. Looking back on code I wrote six months ago, I want to weep.
Legacy code builds up so quickly, even when you think you're doing things well.
We have layer after layer of unfinished transitions in our codebase as we
realize this or that pattern might help us manage all of our stuff more
effectively. (This may be in part due to my ADHD...) It's a huge cludge, and
it's still the cleanest codebase I have ever worked in!

On that dichotomy
-----------------

When talking about engineers, we often divide people into two camps. There are
the people who tend to care more about product and the people who care more
about the craft of the code. Even with her appreciation for code quality and
testing, our CTO is still very driven by the product. She doesn't care about
code quality the way that I do. It just doesn't float her boat. It is not just
business concerns and "higher ups" who push for getting things built quickly,
there are many people who are actually building the product who are primarily
motivated by seeing something in front of users.

And that is fine. It takes all kinds. Part of what makes our team so effective
is the diversity of motivations. I have heard this phrasing of "Conjurers vs
Scribes" which tries to classify engineers into these two camps, but in my book
you are not an effective engineer unless you are both. If you are motivated by
the end product, it is important that you are able to appreciate the value of
code quality and knuckle down to it even though it's not your bread and butter.
And likewise, if you are like me and love to do things right, it is also
important to make sure you are able to ship product.

It gets better
--------------

Doing things the "right" way is a privilege that comes with experience. On one
hand, that might seem pretty messed up and frustrating, but on the other it
makes a lot of sense. If you can show that you are good at getting the job
done, people are more likely to trust your judgement. Authority comes with
experience and expertise–and likely someone relatively early in their career
doesn’t have either in a deep way.

There are nonetheless a lot of companies out there that value doing things well
in addition to quickly. [Ours][chalk], for example, as well as some higher
profile consultancies. You might also look for companies that are more in a
"maintenance" phase, where they have got a solid product and just want to keep
it stable and performant.

Hang in there. Crafting high quality software is a worthwhile pursuit, and
becomes its own reward. It may not be appreciated by the masses, but that is
true for many things of actual value.

[saron-post]: https://medium.com/startup-grind/i-dont-belong-in-tech-3d73d8fd6f34#.2sy7sm31m
[the-burrow]: http://www.themeparktourist.com/sites/default/files/u10837/Character_Article/Things_Learned/Universal/Theburrowlongshot.jpg
[chalk]: https://www.chalkschools.com/

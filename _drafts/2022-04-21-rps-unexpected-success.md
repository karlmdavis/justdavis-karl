---
title: "Should I Keep an Unexpected Success Running?"
layout: post
date: 2022/04/21
categories: RPS Tourney
description: "What do you do when your silly, almost-decade-old side project finds an audience?"
---

Almost a decade ago,
  I launched a very silly side project:
  [RPS Tourney: an online rock, paper, scissors game](https://rpstourney.com).
I'd like to note that this was _intentionally_ silly:
  I was very bored at work
  and needed something to do in my free time that didn't matter,
  but provided me enough creative freedom to be interesting.
A stress-free side project:
  something I could just futz with,
  without stressing about how to monetize it.

Given that very modest goal,
  it was a great success!
I started work on it in October of 2013,
  and was able to stay interested enough to
  futz with it for the next couple of years.
It got me through those two years of very boring day-job work
  and gave me an opportunity to play with enough code to stay sane.

I've poked at it off and on occassionally since then,
  but mostly?
I've just ignored it.
Weirdly, though,
  it's done pretty well attracting users:
  it's gone as high as 835 unique users per month.

<img
  alt="RPS Tourney Monthly Users for 2020 through 2022"
  src="{{ '/assets/images/2022-04-21-rps-unexpected-success-monthly-users.svg' | prepend: site.baseurl }}"
  width="100%" />

Unfortunately, time hasn't been kind to it,
  particularly lately.
Usage has dwindled, which is fine:
  again, "success" for this project was achieved years and years ago.
More importantly -- and urgently --
  there has been a series of Java security vulnerabilities lately.
This project has been running on the same server as my home network:
  if it gets compromised, so does my email, file server, etc.
That's... not great.

So it's time to make a hard choice:
  do I invest the effort needed to keep the project alive,
  or do I shut it down and let it fade into the sunset?

This is a pretty classic product management question --
  the kind of thing that comes up all the time at work.
Somehow, though, it's harder when it involves something this personal.
Nevertheless, let's figure it out.

What goals and objectives
  does keeping [RPS Tourney](https://rpstourney.com) alive
  accomplish for me?

1. It could provide a low-stakes,
     but still real,
     test bed for playing around with technology.
    * Supporting Point:
      I have been wanting to play around with some things at home, of late.
    * Counter Point:
      [RPS Tourney's commit history](https://github.com/karlmdavis/rps-tourney/commits/master)
        is pretty sparse lately: only a few commits a year.
      Maybe this _will_ change sometime soon,
        but I should probably discount the chances of that a bit.
2. It could act as a portfolio piece.
    * Supporting Point:
      Well, if you're reading this blog post,
        it's working at least _kinda'_ well.
3. I like having it around;
     I'd be sad to see it go.

This is, of course, entirely subjective
  but that's a pretty compelling "pro" case for me --
  particularly item #3.
That's not a blank check, though:
  how much effort will be required to make this project safe to keep around?

1. Evaluate it for exposure to recent security vulnerabilities.
    * I'd estimate this as likely to take 2.0h.
2. Get it building
     (it currently depends on some library repositories
     that are no longer available).
    * I'd estimate this as likely to take 20.0h.
3. Move builds for it away from
     the Jenkins and Nexus instances that it used to use
     (which are no longer even available)
     and over to
     [GitHub Actions](https://github.com/features/actions) and
     [GitHub Packages](https://github.com/features/packages).
    * I'd estimate this as likely to take 4.0h.
4. Update its dependencies to current versions,
     particularly Spring, Tomcat, and Java.
    * I'd estimate this as likely to take 20.0h.
5. Update its usage of
     [Google Analytics](https://analytics.google.com),
     as Google has been sending me emails
     telling me that the current setup will stop working soon.
    * I'd estimate this as likely to take 2.0h.
6. Containerize its deployment and hosting,
     and also consider moving it to AWS or something like that,
     so that future vulnerabilities don't put my home network at risk.
    * I'd estimate this as likely to take 24.0h,
        if I leave it on my personal server and host it via Docker Compose,
        or 60.0h if I decide to move it to AWS.

All together, that's an estimate of at least 72.0h of work.

In all honesty, that's a bit higher than it's probably worth to me.
That's two or three months' worth of my (very limited) free time,
  and while it'll be fun,
  I've got other side projects I could work on instead
  that would be _more_ fun.
At a minimum, I need to take care of the first item there,
  evaluating the application for vulnerabilities,
  as that will help me figure out how urgently I need to make a decision.

But beyond that, I'm going to have to think about this some.

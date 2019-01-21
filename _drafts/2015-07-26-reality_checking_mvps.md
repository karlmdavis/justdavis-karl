---
layout: post
title: "Way Longer Than Expected"
date: 2015/06/14
categories: coding
description: "How long would you expect you'd need to build a simple web game? My first attempt left me very surprised..."
---

## The Dumbest Project

A few years back, I found myself feeling frustrated:

1. I was spending most of my time at work managing and training a team.
2. I had no time at work to do any hands-on engineering work myself.
3. I had signed an IP Assignment agreement that gave IBM, my employer, ownership of __anything__ I did in my spare time.

The first one, by itself is fine: I enjoy managing teams and especially enjoy helping junior developers to grow. However, combining that with a complete inability to write code either at work or in my free time left me feeling rather frustrated. I **need** time to play with code.

As I previously discussed in [What On Earth Was I Thinking?]({{ site.baseurl }}{% post_url 2015-07-27-what-on-earth-was-i-thinking %}), my solution was to start a side project so dumb that IBM will never bother to assert ownership of it: a multiplayer Rock-Paper-Scissors game. It was, and remains, the dumbest project. Intentionally, though.

## Tracking A Waste of Time Isn't a Waste of Time

When I started the project, I didn't really have an end goal in mind beyond "ship something that (mostly) works." I didn't plan out features until well into the effort and didn't put much up-front thought into how long it all might take. I also intentionally chose to use a bunch of technologies, libraries, etc. that were new to me. It was a good chance to learn some new stuff and try out some ideas. I was just farting around.

Once I got past the most basic command line prototype, though, I started doing some project planning and estimation. I also started tracking my time, in detail. In retrospect, that time tracking data has proven to be one of the most valuable takeaways from the effort: I've got a great data set on what a greenfield project takes to get to the MVP stage.

Let me sketch out the basic goals and functionality for you:

* Create a multiplatform online Rock-Paper-Scissors game, backed by a web service that handled all of the game play itself.
    * The targeted platforms were just a command line application and web application.
    * As an experiment, I also wanted to see if I could build the web app in a way that it'd work even if JavaScript was disabled.
* Allow users to play against a basic computer opponent or each other.
* Allow users to either register for an account or to play anonymously.
* Get the whole thing to the level of a Minimum Viable "Product": feature complete enough to be interesting and with no horrifying bugs.
    * "Product" is a bit of a misnomer, since I had no intention of trying to monetize the thing.
* Use a mix of familiar and unfamiliar technologies.
    * For example, I decided to stick mostly to Java, which I was already very familiar with.
    * For example, I wanted to try out Spring MVC, which I hadn't used before.

Stop and think about that list for a minute: how long would you expect a project like that to take, in person-hours? I mean, it's a Rock-Paper-Scissors game: intentionally the dumbest thing I could up with. From some completely non-scientific polling I've done, most software engineers think it's the kind of thing that could be knocked out in a week or so: 40 hours, give or take.

## It Took How Long?!

How long did it take me? Turns out: about 700 hours. WTF?!

See for yourself: I tracked all of my time in this text file here: [rps-tourney.git/dev/work-log.md](https://github.com/karlmdavis/rps-tourney/blob/master/dev/work-log.md). I also wrote a hacky little parser for that file ([work-log-parser.py](https://github.com/karlmdavis/rps-tourney/blob/master/dev/work-log-parser.py)), which I then used to produce the following analysis <a id="ref-1-source"><sup>[[1]](#ref-1-target)</sup></a>.

<table>
  <tbody>
    <tr>
        <td style="font-weight:bold">Start Date:</td>
        <td>2013-11-04</td>
    </tr>
    <tr>
        <td style="font-weight:bold">Stop Date:</td>
        <td>2015-12-29</td>
    </tr>
    <tr>
        <td style="font-weight:bold">Days Elapsed (Calendar):</td>
        <td>785</td>
    </tr>
    <tr>
        <td style="font-weight:bold">Days Worked (Actual):</td>
        <td>631</td>
    </tr>
    <tr>
        <td style="font-weight:bold">Total Hours Worked:</td>
        <td>667</td>
    </tr>
    <tr>
        <td style="font-weight:bold">Average Hours Worked per Day:</td>
        <td>63</td>
    </tr>
  </tbody>
</table>

## Shouldn't Have Been a Surprise

I was just as surprised as you probably are at how long it took to complete. I probably shouldn't have been, though. I've seen the same sort of thing over and over throughout the course of my career.

> <p>The last 10% of a project takes 90% of the time.</p>
> <p style="padding-left:2em">—Every Engineer Ever</p>

> <p>Take your estimate and double it. (Or triple it.) (Or whatever.)</p>
> <p style="padding-left:2em">—Every Other Engineer Ever</p>

Looking back at the time log and my initial estimates, there are a few things things going on.

First, a large part of the work wasn't, and couldn't have been, estimated out during up-front planning: I'd only estimated 18 tasks for a total of almost 200 hours of work. But there were dozens of other tasks included in that initial planning that I couldn't estimate yet and dozens more tickets that ended up being filed along the way to getting the whole thing done.

Second, there's a large distance between building something feature-complete enough that it _works_ and something feature-complete enough that it's useable by the general public. [Issue #87: "The webapp UI needs to be more awesome"](https://github.com/karlmdavis/rps-tourney/issues/87) is great example of that: my first-pass UI and UX kinda' sucked. I mean, it worked, but no one would have _enjoyed_ using it. Improving that took 23 hours of tweaking, user testing, more tweaking, etc.

Finally, my estimates also failed to account for some of the infrastructure that is needed to safely run a site on the public internet: deployment automation, monitoring, dashboards, CDNs, perfomance testing, etc. I did end up putting some of that in place towards the end (e.g. deployment automation) but I've also been living dangerously and skipped over other pieces (e.g. dashboards). If this was something I cared about at all, though, I'd have to go address the missing pieces there. 

In the end, the amount of time all of this took should not have been a surprise. But it was. Us engineers are always optimists and lean on our intuition far more than we'd care to admit. When something "feels" like it should be quick and easy, any estimates we produce will reflect that. The only solution to that is experience and careful planning. This project was a great object lesson to me on just how much care and effort needs to go into even the simplest thing.

Hopefully, I've been able to pass on some that lesson to you, here.


<a id="ref-1-target">[[1]](#ref-1-source)</a> I cut this analysis off as of 2016-12-29, as everything done after that is really just post-release maintenance work — and I was mostly ignoring the project at that point, anyways.

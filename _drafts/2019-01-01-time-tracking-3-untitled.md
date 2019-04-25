---
title: "Time Tracking: Third, Untitled"
layout: post
date: 2019/01/01
categories: Time Tracking
description: "TODO"
---

## Brainstorming

* Why did I want to switch from the spreadsheet to SQLite?
    * I think I assumed something more "formal" would be necessarily better.
    * I wanted a way to easily pull in GitHub data.
    * Just to see what'd happen.
* Was switching to SQLite a good idea? Do I want to keep using that version?
    * Sort of...
    * The GitHub integration is **great**; updating all of that shit by hand was a mess.
    * The exploratory human UX for SQLite kinda' sucks, though.
    * But... I can also see a lot of potential future advantages in being able to pipe queries out of SQLite and into other things.
* Let's step back from this specific thing, and think broader: what are the pain points with my current time tracking systems?
    * Work wiki:
        * Starting to fall over with as much info as I've shoved into it.
        * Not doing detailed time tracking there, so I wouldn't be able to pull out anything structured from it. That could change.
        * However, given work's security nonsense and Confluence being dumb, I wouldn't be surprised if I had trouble extracting the data from it.
    * RPS project:
        * A lot of the tasks don't have any estimates.
        * I had several release plans (i.e. milestones) but GitHub doesn't provide any great way of pulling that data back out, retrospectively. As a result, I can see my estimates at the task level but not at the overall release level.
    * Time app:
        * I haven't bothered to create tickets for much of anything yet. Why?:
            * Wanted to keep things flexible at the prototype stage, rather than pretend I knew where things were headed.
            * Haven't taken the time to convert my backwards plan into tickets.
* Let's drill into a couple of those a bit:
    * Why _aren't_ I doing detailed time tracking in the work wiki?
        * Because I task switch too frequently.
        * Every time I've tried to do it I get to the end of the day and have a mess on my hands that takes forever to be cleaned up, if it can be at all.
        * The refresh --> login --> edit --> save cycle on Confluence fucking sucks: takes way too much time to make simple changes.

Okay, I think my SQLite work will end up being not super useful here. Instead, let's write a blog article around that middle question: "what are my time tracking pain points and what could be done to ease them?"

## Body

"Am I spending my time well right now?"

That question is why I track my time: I'm trying to find an answer to it. Unfortunately, the times when the answer to that question is most critical, the times that I'm busiest, are the times that I tend to stop tracking my time at all. "Is the busy-ness I'm going through right now the good kind, where I'm heads-down on the work that matters the most, or the bad kind, where I'm wasting time on trivialities? Or is it the really bad kind where it's less that I'm busy and more that I'm burned out and thus wasting large swathes of time staring at Twitter?" Reflecting after the fact, I can perhaps guess which of these modes I was in. But if I was tracking my time, I'd have the hard data to answer the question for sure.

Another problem I have with my current approach to time tracking is that I end up with separate logs for each project: one log for my work day (in the company wiki), one log for this side project in its Git repo, a log over there for that project, another log for my blog, etc. [My current approach](TODO) is **much** better than nothing (and I'd strongly recommend you try it out if you aren't tracking your time at all), but I really do wish I had a single unified log across all of my projects. It'd be nice to see how my time is split up between all those parts of my life.

I'd also really love something that could tell me what I've been up to on my phone. Over the past few years, most of my goofing off -- browsing Twitter, etc. -- has moved to my phone, and it'd be great to have data about that. As a nice side bonus, getting data from my phone would also allow me to keep track of how much of my work day is _really_ being spent in meetings. I know what my calendar says, but most of my meetings run over or under by quite a bit. The real source of truth for how much of my day is getting sucked up by meetings would come from my phone.

Back when I was a Windows-only kind of cat, there was a great tool I used to help with all of this: [ManicTime](https://www.manictime.com/). It would just run in the background, collecting data on what I was up to, and I could come back later -- even weeks later -- and use that data to figure out what I'd been up to. I miss ManicTime a lot. Unfortunately, though, it just won't work for me anymore. For one, I spend most of my time on Linux. But the real showstopper is that I spend a lot of time working & playing across a number of devices and need something that will track me across all of them -- without sharing that data with a sketchy company I only half-trust [1].

## Baby Steps Towards a Solution

I've recently started taking some baby steps towards solutions to these problems.

For one, I've started playing around with converting my manual time tracking data to SQLite. I'm not sure if/how this will ultimately pan out, but I'm trying to build a solid set of command line tools that make it much easier to track and view how I'm spending my time. Timers, tags, and reporting -- those are my goals. I want to strike a balance that gives me richer data than my current text format without sacrificing any ease or useability. Ideally, the end result will actually be even easier to use.

In addition, I've built a Linux application that keeps track of which applications I'm working in (and the window titles). It's still super rough around the edges, but it's a solid step towards being able to collect this data everywhere. For funsies, I've built it in Rust, which was a surprisingly great choice: fun to write, very robust, and also vanishingly lightweight at runtime.

Neither of those is ready to share yet, but I'm working on it. I'm also still looking for other privacy-respecting options, so [let me know](TODO: twitter) if you've come across some!


[1] Sorry, [RescueTime](https://www.rescuetime.com/features): I think that sending you a detailed timeline for every day of my life is pretty creepy.

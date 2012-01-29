--- 
title: "Retrospective: Ridgetop Postmortem"
kind: article
created_at: 2009/12/20
tags: []
excerpt: "TODO"
publish: false
---

I recently left my [job of the past three years](http://www.ridgetopgroup.com) for [another opportunity](http://www.knowledgecc.com) here in Tucson.  As 2009 comes to a close, I find myself in a retrospective mood.  It seems appropriate to look back on and evaluate the engineering decisions that I made at Ridgetop-- determine what worked well and what I would do differently.

## Outline

[TODO: remove when done]

* Background
* Stuff That Worked
    * Toolchain
    * Agile Engineering
* Controversial Decisions
    * Project Proliferation
    * Agile Project Management
    * Training
    * Code Reviews

## Background

Ridgetop Group, Inc. is a small business focused on research and development, primarily in the field of electronics.  Founded in 2000, they've successfully completed dozens of government and commercial contracts to advance the start of the art in robust electronic systems.  I started with Ridgetop in the Fall of 2006, hired to help them develop a new software application for one of those contracts.

At that point in time, I was pretty green.  I'd only been out of school for a short while and this was my first full-time gig.  I'd done a fair amount of contract work prior to starting at Ridgetop, but it was all small-scope stuff compared to what I ended up working on there.  Green or not, I was the only full-time software engineer at Ridgetop and had to develop a lot of experience, quickly.  I was working under a couple of folks with some experience in software, but neither of them were really "hands-on" coders (anymore) and could only provide very high-level direction/instruction.

Over the course of those three years, I grew from that green software engineer to technical lead of a small team on a succession of projects.  I had some great successes, made some mistakes, worked with some very sharp folks, and learned a lot.  At the end of it, I find myself with a fairly firm approach to software design and engineering.  My goal here is to describe that approach briefly, focusing on how well various aspects of it worked out (or not) in the end.

## What Worked

### Toolchain

Over my three years at Ridgetop, I put together a software development toolchain that rocked.  I'm certainly a better developer than I was three years ago, but the biggest boost to my productivity has been from the collection of tools &amp; libraries I've combined to get stuff done.  I've described all of these in a separate article already: [TODO].  Obviously, substitutes exist for a number of the tools and libraries I selected for use at Ridgetop but, overall, I'm quite happy with how they worked out.

### Agile Engineering Practices

I went through that entire first project at Ridgetop without writing any unit tests.  That didn't work so well: lots of little failures here and there and it seemed like every time I fixed one thing, I broke another.  Towards the end of that project, another engineer and I went through and tried to put together a suite of scripted GUI tests.  Those integration tests were much better than nothing, but they were also incredibly brittle-- it took a lot of work to maintain them.

Those experiences have made me a firm believer in unit tests.  All the projects I ran at Ridgetop after that first had a solid suite of unit tests backing them up.  This greatly improved the reliability of our code.

## What Didn't Work

TODO

## Agile Project Management

TODO

After a couple of frustrating experiences running projects with waterfall processes and practices at Ridgetop, I made a push to adopt something more flexible.  For the relatively small research and development projects I was heading up, waterfall seemed like a poor fit.  Too much focus on requirements documentation and not enough focus on customer interaction.

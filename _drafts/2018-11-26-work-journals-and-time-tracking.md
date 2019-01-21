---
title: "Work Journals and Time Tracking"
layout: post
date: 2018/11/26
categories: Time Tracking
description: "Tracking the tick-tock of my work days and projects."
---

I love having detailed notes on how I spent my time while working on a project.

I love having the data it provides: I can easily see and run reports on where my time has been spent. I can compare my initial rosy-eyed estimates to harsh reality <a id="ref-1-source"><sup>[[1]](#ref-1-target)</sup></a>. I can keep track of how many hours per week I'm putting in, to keep myself honest on work-life balance. It's great!

If I'm really organized, I'll put together a whole list of priorities and tasks that I hope to tackle, then track my time against those items as I go through the day. Usually, I take the extra step of posting all this publicly on the company's internal wiki, so that it's easy for my managers and coworkers to see what I'm up to each day. Something like this:

<blockquote>
## Strategic Priorities

1. Make progress on Project _The New Hotness_.
2. Make sure that the folks working on _Other Great Thing_ aren't blocked.

## Specific Tasks

* Done: Review Jane's PR: <https://github.com/ourcompany/hotness/pull/987>.
* Made Progress: Finish [Ticket #12345: Fix that horrible bug Karl created](https://issues.ourcompany.org/12345).
* Done: Meeting 1600-1700: Hotness sprint planning.
* Didn't Get To: Answer yesterday's email from John.
* Done: Stop by Fred's desk and thank him for that thing he did.

## Hours (8:15h total)

* 0:45h (0800-0845): Reviewed Jane's <https://github.com/ourcompany/hotness/pull/987>.
    * Not quite clean; will need another round once she's added in that whizbang we discussed in the comments.
* 0:30h (0845-0915): Chatting with Fred about Ticket #12345.
    * Personal note: His kid has a big concert coming up this Friday he's excited about.
* 5:30h (0915-1200,1300-1545): Worked on Ticket #23456.
    * Got most of the existing tests passing, but need to finish that then add one or two additional cases to cover the new stuff being added.
* 1:30h (1545-1715): Sprint planning prep and meeting.
    * Still need to go flesh out Tickets #34567 and #45678.
</blockquote>

This kind of note-taking/journaling is super useful as I'm almost always working on a bunch of separate things at once: it helps me keep things straight in my head. The time tracking is useful, too: it helps me figure out which projects I'm actually spending my time on. It's great to periodically compare those time-spent totals against my actual priorities, and see if I'm spending my time optimally.

On some of my projects, I've standardized the format enough that I can parse it with some simple scripts and convert it into machine-analyzable data. I then get to use that data to answer fun questions like:

* How much of my time is being spent on new feature work vs. bug fixes?
* How accurate were my estimates for our latest release?
* How much of my time was spent on planned vs. unplanned work?

Being able to answer questions like that is a kind of superpower: it allows me to make the adjustments I need to spend my time wisely.


<a id="ref-1-target">[[1]](#ref-1-source)</a> Related: [Software Project Estimation: Rebuilding Trust]({{ site.baseurl }}{% post_url 2015-08-16-software-project-estimation-rebuilding-trust %})

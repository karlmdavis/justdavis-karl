---
title: "Time Tracking: A Love-Hate Relationship"
layout: post
date: 2018/11/26
categories: Time Tracking
description: "I have a love-hate relationship with time tracking. I wish there was a good software solution to help."
---

I have a love-hate relationship with time tracking.

I love having the data it provides: I can easily see and run reports on where my time has been spent. I can compare my initial rosy-eyed estimates to harsh reality <a id="ref-1-source"><sup>[[1]](#ref-1-target)</sup></a>. I can keep track of how many hours per week I'm putting in, to keep myself honest on work-life balance. It's great!

I hate keeping up with all the data entry. I particularly hate it when it's employer-mandated, as that inevitably comes with inconvenient submission deadlines: usually Friday end of day, when I'm just trying to wrap things up and get out the door. Honestly, it's embarassing how bad at this I end up being: folks are always yelling at me for submitting timehseets late.

It's not so bad when things are going well and aren't super busy: I just make notes as I go through the day on what I worked on. If I'm really organized, I'll put together a whole list of priorities and tasks that I hope to tackle, then track my time against those items as I go through the day. Usually, I take the extra step of posting all this publicly on the company's internal wiki, so that it's easy for my managers and coworkers to see what I'm up to each day. Something like this:

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

## Hours (8.25h total)

* 0.75h: 0800-0845: Reviewed Jane's PR.
    * Not quite clean; will need another round once she's added in that whizbang we discussed in the comments.
* 0.5h: 0845-0915: Chatting with Fred.
    * His kid has a big concert coming up this Friday he's excited about.
* 5.5h: 0915-1200,1300-1545: Worked on Ticket #12345.
    * Got most of the existing tests passing, but need to finish that then add one or two additional cases to cover the new stuff being added.
* 1.5h: 1545-1715: Sprint planning prep and meeting.
    * Still need to go flesh out Tickets #23456 and #34567.
</blockquote>

That kind of tracking is super useful, especially if I'm working on a bunch of separate things at once: helps me keep track of where things are at. The time tracking is useful, too: helps me figure out which projects I'm actually spending my time on. It's great to periodically compare those time-spent totals against my actual priorities, and see if I'm spending my time optimally.

But keeping track of all that isn't free: it takes up fifteen or thirty minutes of each day. When I get busy, it's one of the first things to start getting skipped each day. That's unfortunate, because the prioritization would would be most useful during those hectic times. When the choice is between keeping up with my notes and time tracking or getting the actual products shipped, though...

## Software to the Rescue?

For a brief, glorious period of my working career, I used a tool called [Manic Time](https://www.manictime.com/) to help: Manic Time presents a helpful timeline of all the things I did on my computer each day. I could review that timeline once a day or once a pay period or once things calmed down a bit and figure out -- after the fact -- where my time had gone. It was great!

Except:

* It's Windows-only.
* It doesn't sync data across multiple devices.
* It doesn't track time spent on calls (though it does have Outlook integration, which can help).

Unfortunately, it just doesn't support my multi-device, not-often-in-Windows, work lifestyle. I wish it did: it was some of the best money I'd ever spent.

I've looked around at some of their competitors, and it doesn't seem like they provide an acceptable solution, either. A few of them are multi-device, but those all seem to want me to send them a stream of every window/application I use, on every one of those devices. Unencrypted. That's a **terrible** idea, from a security perspective. And creepy.

Anyone know of a privacy-conscious, multi-device offering in this space?

Until then, I'm still updating the company wiki by hand, every day, all day (except when I get busy and it matters most).


<a id="ref-1-target">[[1]](#ref-1-source)</a> Related: [Software Project Estimation: Rebuilding Trust]({{ site.baseurl }}{% post_url 2015-08-16-software-project-estimation-rebuilding-trust %})

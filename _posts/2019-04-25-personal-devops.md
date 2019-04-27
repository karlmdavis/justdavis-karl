---
layout: post
title: "Personal DevOps"
date: 2019/04/25
categories: DevOps
description: "DevOps is all about trying to improve a team's productivity, but sometimes, the best place to start is with ourselves."
image: "/assets/2019-04-25-personal-devops-hamster.jpg"
---

## DevOps-ify Your Own Damn Self

DevOps is often viewed as being all about technology, automation, and fun stuff like that. But at it's core, it's really about _people_: how can we facilitate teamwork, create a collaborative culture, and create an environment for good work to happen in? Sometimes, the answer _is_ automation. A lot of the time, though, it's about changing how we work in more basic and fundamental ways.

If you're interested in DevOps beyond just "automation is fun!" then you probably care deeply about improving your team's productivity. For productivity, the best place to start is with ourselves. I want to show you how I apply DevOps practices like improving communication, tracking metrics that matter, and more -- to try and get the most out of each work day.

<span style="font-style: italic">Quick Note: This blog post covers the same content as an Ignite Talk that I gave at [DevOpsDays Baltimore 2019](https://www.devopsdays.org/events/2019-baltimore/welcome/). You can find my slides here: [Personal DevOps: slides](https://drive.google.com/open?id=1eSnD457h2KM2jjBIY7Al8cGTLwiPIknfM_INjs8jAZM), and once the recording is available I'll provide a link to that here, too. If you haven't been to your DevOpsDays conference or local DevOps meetup, you should check it out! They're full of lovely people.</span>

## A Lttle Bit Goes a Long Way

Lots of folks in tech are interested in this kind of stuff. See: quantified self, life hacking, Soylent, etc. It also tends to get pretty weird and unhealthy in a lot of cases. See: [@jack](https://twitter.com/jack) going off to genocidal Myanmar to meditate, Soylent, etc.

But. There are some useful ideas and practices here that can be a part of a healthy work day. I want to chat about those pieces I've found and adopted.

## DevOps Principle: Transparency

<img alt="Photo of person carrying large stack of boxes." src="/karl/assets/2019-04-25-personal-devops-carrying-boxes.jpg" style="border: 1px solid black" width="300px" />

> People keep asking me to do more but they don’t know how busy I already am!

We're all busy. If you're like me, you've got a backlog of things that need to get done that's dozens long. Maybe, like me, you also worry about all of the people waiting for you to complete those items... Are they mad at me? Do they think I'm some kind of jerk for not having already taken care of their particular items? How can I help them understand where their items land in my current priorities?

"Geez Karl, just use Trello or JIRA or whatever; that's what they're for." True! But there are lots of things on my backlog that just aren't worth the paperwork and time that creating tickets for them would require.

* "Go ask Bob about the whatsit."
* "Convince Fred that the thingamabob needs to have a whosit."
* "Schedule a meeting to discuss the dingeyfarkle."

What if, instead of worrying about how angry folks are getting, you could instead rest assured that everyone knows what you're up to — they understand exactly what your backlog and priorities look like?

Simple solution: apply the DevOps principle of Transparency by working openly. Create a page in your team's wiki, title it "Karl's Daily Work Log" or something like that. At the top of the page, add a "Backlog" section and start moving that list of dozens of items out of your brain and into the wiki. Right below that, add a section every day with the date and list the items you're planning to get to, your meetings, etc. — in the order that you plan to get to them.

![Screenshot of wiki page with backlog and current day's tasks.]({{ "/karl/assets/2019-04-25-personal-devops-daily-log.png" }})

As new action items land in your lap, or as folks ask you for the status of those items, point them at your wiki page. If your wiki supports it, liberally @-mention folks, so that they're automatically notified about updates.

Congratulations! You've now solved your problem in just about the simplest way possible. You're working in the open, and no one needs to worry about what you're up to.

## DevOps Principle: Long-Term Focus

<img alt="Application icons for Mail, Google Calendar, and Slack, with badges indicating lots of unreads." src="/karl/assets/2019-04-25-personal-devops-notifications.svg" style="padding: 5px; border: 1px solid black" width="250px" />

> Ugh, it feels like I spent all my time today on email and meetings.

Don't get me wrong: emails and meetings are **absolutely** important work. But that's generally because they _facilitate_ the product and other work that more directly delivers customer value. Left unchecked, though, those important (but distracting!) emails and meetings will constantly interrupt the other work that needs to be done, which requires focus.

What if, instead, you and your team could get to the end of the week feeling like,

> Wow, look at how productive we all were this week! We moved the product — and our customers — so much forward!

Here's how you get there: apply the DevOps principle of having a Long-Term Focus to transform how you & your team work. Two things to do...

First, as a team, set aside a two hour or so block in the afternoons for any/all meetings. That's when you schedule your meetings. That's when you open up your email clients and work through your inbox. That's the time your team dedicates to the collaboration that's critical for success.

<img alt="Screenshot of calendar day with most time reserved for heads-down work." src="/karl/assets/2019-04-25-personal-devops-calendar.png" style="padding: 5px; border: 1px solid black" width="400px" />

Second, at the start of every day, go to your "Daily Work Log" wiki page. Write down, and then answer this question at the top of the section for your day, first thing:

> What can I do today that will still matter a year from now?

<img alt="Screenshot of daily log page in wiki. Question: calendar t can I do today that will still matter a year from? Answer: Move TICKET-12345 along: that will really help our customers!" src="/karl/assets/2019-04-25-personal-devops-daily-log-with-goal.png" />

What you're trying to do here is start every day with a Long-Term Focus. Get out of that firefighting mode; stop worrying so much about all of the minor things on your backlog and instead keep an eye towards the work that will ultimately matter the most for your customers.

## DevOps Principle: Monitoring & Analytics

<img alt="Photo of hamster running in exercise wheel. Very cute!" src="/karl/assets/2019-04-25-personal-devops-hamster.png" style="border: 1px solid black" />

> I'm working like a _hundred_ hours a week lately. It's killing me.

Our culture, and tech in particular, has a very unhealthy relationship with work. There's always more work to do than there is time or people. I've certainly been in situations where I felt like the best (or maybe only) option was to sacrifice my sanity and family time in order to get shit done at work.

When we're hiring, there's always a lot of pressure to sweep these problems under the rug.

> We have _great_ work-life balance here. It's wonderful!

What if this was... actually true? Wouldn't that be something?

The thing is, we just don't have the information we need to take an honest look at this problem. What we need to do first is to apply the DevOps principles of Monitoring & Analytics. By taking a data-driven look at our work time, we can find ways to optimize it, and also keep ourselves honest.

I'm a bit weird, but maybe you are too: I _hate_ being forced to track and submit my time, but I've found that I _love_ collecting this data myself for my own personal use. I think if you experiment with it for a few weeks yourself, you'll find that you appreciate it, too.

Step one: start recording all your work hours, in five minute blocks or something like that. When you got in for the day. Your lunch break. When you left for the day. The twenty minutes you spent at night checking your email. Record all of it somewhere.

<img alt="Screenshot of daily log page in wiki, with work hours logged." src="/karl/assets/2019-04-25-personal-devops-daily-log-with-hours.png" />

Step two: use [RescueTime](https://www.rescuetime.com/) or something like it to track _how_ you're spending all of that work time. How much time are you spending blocked? How much of your time is being spent well vs. how much of it was probably wasted time?

<img alt="RescueTime logo." src="/karl/assets/2019-04-25-personal-devops-rescuetime-logo.svg" style="padding: 5px; border: 1px solid black" width="300px" />

This is an experiment. Collect the data for a few weeks, then put it all together at the end and analyze it. I guarantee that the results will shock you. And you'll find some obvious productivity improvements you can make that will reduce the pressure you're under to sacrifice your work-life balance. Also, intriguingly, if you're tracking the hours you worked, you'll find that you were actually exaggerating how bad your work-life balance really is. <a id="ref-1-source"><sup>[[1]](#ref-1-target)</sup></a> Bringing some reality to that feeling can only be healthy.

## DevOps Principle: Empathy

<img alt="Woman wearing boxing gloves punching man in face." src="/karl/assets/2019-04-25-personal-devops-punch.jpg" style="border: 1px solid black" width="400px" />

> It feels like everyone’s attacking each other — playing CYA and the blame game — when things get tough, rather than attacking the problem.

This is a tough problem: some workplaces just have an unhealthy culture that, when things go sideways, everyone is more focused on _themselves_ than they are on the _customer_. We're all humans, and the urge to be defensive is very natural. But that kind of culture will almost inevitably have some very real negative effects on your customers — and your business.

What if, instead, everyone pulled together? What if you could say...

> Sure, our team has a solid Incident Response process, but our real secret weapon is that everyone...
>
> Is just super helpful!

No quick fixes here: if your workplace culture has started going in the wrong direction, it'll take time to change. But the solution is nonetheless deceptively simple: you and your team need to practice empathy. Empathy for each other and empathy for your customers is the cure for cultural problems like this. This will need to happen in lots of little ways:

* Listen to your team members and your customers; give folks space to tell you about themselves.
* You know how at the start of a meeting, someone inevitably says, "Okay, okay... enough chit chat. Let's get to our agenda here?" No: don't do that. Instead, encourage the chit chat; it's the most important part of the meeting.
* Along with your Incident Response processes, SLAs, and all that, ensure that your teams have regular "water cooler meetings" for folks to get to know the other teams and people that they rely on.
* When folks are struggling with something, be sure to always respectfully offer help.

<img alt="Cheesy photo of four people around a table doing a group high five." src="/karl/assets/2019-04-25-personal-devops-team-high-five.jpg" style="border: 1px solid black" width="400px" />

Over time, these little acts of empathy will build the trust and connections your team needs to succeed.

## DevOps Principle: Heroes Not Needed

<img alt="Photo of seaside cliff with sign: Unstable cliffs. Danger. Stay back. No public access." src="/karl/assets/2019-04-25-personal-devops-cliff.jpg" style="border: 1px solid black" width="400px" />

> It feels like everything's _this_ close to falling apart.
>
> The only thing standing between this project and failure is me: the sheer force of will I'm applying to hold everything together.

You may not say this aloud (_hopefully_ you don't!), but I suspect we've all thought it at some point or other. Yuck. Such a warped perspective.

What if you _weren't_ a gross Stress Lord like this? Instead, when folks ask you how your project is going, you could say...

> Well, we're all a little busy, but the team's on top of it.
>
> Thanks for asking!

Here's the super duper secret solution: **Get. Some Fucking. Sleep.** The end. Thanks for coming to my Ted Talk.

... but seriously: go get some sleep. Everytime I get all stressed like this, it turns out it's mostly because I'm super tired. And I'm super tired because I'm staying up way too late working (but mostly worrying). Stop that. Go to bed on time. Maybe even take a couple long weekends and relax some. <a id="ref-2-source"><sup>[[2]](#ref-2-target)</sup></a>

<img alt="Photo of person faced-down in bed with just their feet showing from under the covers." src="/karl/assets/2019-04-25-personal-devops-sleep.jpg" style="border: 1px solid black" width="400px" />

Sleep and relaxation will radically change your perspective. Few weeks back, I was feeling pretty stressed out and sorry for myself about things at work. Then I got sick. Spent the better part of three days sleeping, pretty much nonstop. After recovering and heading back in to work?

Turns out, everything was fine all along. The team's got this. My Hero Complex was neither needed nor helpful.

## Conclusion

At the end of the day, the DevOps philosophy is about looking at your product delivery systems in a holistic manner, and making improvements to deliver more value, faster. You can — and should — apply those same analyses and techniques to your personal daily work.

Remember: products are built by people. The most important thing is to empower and trust your team.


<a id="ref-1-target">[[1]](#ref-1-source)</a> Related: [People Who Claim to Work 75-Hour Weeks Usually Only Work About 50 Hours](http://nymag.com/intelligencer/2019/04/people-who-claim-to-work-75-hour-weeks-are-lying.html)

<a id="ref-2-target">[[2]](#ref-2-source)</a> Related: [Tweet from @hillelogram detailing impacts of stress and sleep on productivity](https://twitter.com/hillelogram/status/1119709859979714560)

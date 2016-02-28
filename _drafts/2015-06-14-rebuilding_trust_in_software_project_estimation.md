---
layout: post
title: "Rebuilding Trust in Software Project Estimation"
date: 2015-06-14
categories: coding
description: "Let's be honest here: most developers have an incredibly unprofessional attitude towards project planning and estimation. They don't like it, they really wish it'd just go away, and they may even claim it's impossible."
---

# Rebuilding Trust in Software Project Estimation

Let's be honest here: most developers have an incredibly unprofessional attitude towards project planning and estimation. They don't like it, they really wish it'd just go away, and they may even claim it's impossible. It's not. It *is* challenging to do right, but this just makes it an even more valuable skill for developers to have. Being able to properly estimate a project in advance can often mean the difference between getting it properly staffed or having it end with a [death march](https://en.wikipedia.org/wiki/Death_march_%28project_management%29).

## The Cycle of Estimation Despair

I think almost every coder has had the following conversation at some point early in their career:

> Marty the Manager: "We need an estimate for when Project Foo will be completed."
> 
> Christy the Coder: "Hmmm... this project feels like a three-week effort or so."
> 
> Marty the Manager: "Okay, three weeks. I'll let the customer know."
> 
> [Three or four weeks pass...]
> 
> Marty the Manager: "Christy, the customer was expecting Project Foo to be delivered already! When will you be done with it?"
> 
> Christy the Coder: "Wait... that number I gave you back then was just an estimate – not a promise. You didn't make a commitment to the customer that we'd have it done already, did you‽"
> 
> Marty the Manager: "What do you mean that it was __just__ an estimate‽ The customer has to be able to rely on the timelines we provide them!"

There are two really striking things about this entire mess: the miscommunication on both sides, and how lousy a job we coders all do at producing real estimates. Between these two problems, it's no wonder we suffer so much stress from project planning and the blame game of missed deadlines. 

## Getting on the Same Page

Miscommunication is poisonous. If we can't understand and agree on what the words "estimates" and "commitments" each mean and what the differences between them are, we all quickly learn that we can't trust each other in these kinds of conversations. If Christy and Marty want to solve their problems, they're going to have to sit down and spend some time working through this.

From here on out, I'm going to use the following definitions:

<dl>
	<dt>Estimate</dt>
	<dd>A probability distribution of when a given task or project is likely to complete.</dd>

	<dt>Commitment</dt>
	<dd>A date given to the business or customer, by which a given task or project must be complete.</dd>
</dl>

While commitments almost always require estimates before they can be made, an estimate is in no way the same thing as a commitment. A commitment is most typically a single point in time. For example, Marty might tell his boss that Project Foo will be delivered no later than June 30. That's a commitment.

An estimate is best thought of as a _range_ of effort. For example: Christy might tell Marty that Project Foo has a 90% chance of being complete within 750 person-hours, but also has an 80% chance of being complete within 450 person-hours. Another way of framing that is if Christy and her team were asked to deliver projects similar in size and shape to Project Foo, eight out of ten times those projects would each complete in less than 450 person-hours, nine out of ten times they would complete in less than 750 person-hours, and one out of the ten times would fall outside of either of those ranges. Note that there isn't a linear relationship here: 10% more certainty may add far more than just 10% more person-hours. Estimates are a tool for expressing the uncertainties and variabilities inherent in every project, and those challenges vary wildly from one project to another.

Note also that estimates are not framed in terms of days, or weeks, or other such units of measure; they should always be measured in person-effort-hours. It is up to Marty and the business to decide how many people to have working on Project Foo and to decide how much of their time will be spent on it. If they're smart, they'll ensure that the team is "fenced off" such that they're only working on this one project, as multitasking will slow them down, increasing the number of person-hours needed. For her part, Christy should produce an estimate with a certain staffing level in mind, but if that estimate is in terms of person-effort-hours, adjusting it for different staffing scenarios should be relatively straightforward.

Hopefully, Marty and Christy will also discuss the following:

* Different engineers will be faster or slower than others, with more experienced engineers generally being faster. Was Christy sizing the tasks based on how long it'd take _her_ to do them, or how long it'd take Junior Coder Joe to do them?
* There are probably dependencies between various parts of the project, such that _A_ must be completed before _B_, and so on. It's probably not a great idea to have 15 engineers assigned to the project if 14 of them will be blocked most of the time, waiting for other parts to be ready.
* Adding extra bodies to the project will increase the amount of communication needed within the project team: emails, hallway conversations, meetings, etc. Past a certain number of team members, this communication overhead may very well eat more time than it saves.

It's really important that both Christy and Marty understand the above. Before starting the estimation process, they should meet and talk through the staffing situation and any risks associated with it. Estimates can be adjusted if the staffing situation changes, but it's always better to start the estimation process with that nailed down as much as possible.

## Where Do Estimates Come From? The Birds and the Bees of Estimation

Communication is key, but Christy still needs to leverage something more concrete than her intuition and feelings when producing estimates. Those are good enough for very small tasks of a day or so but for anything substantial Christy needs to: 1) produce a work breakdown, 2) estimate all of the parts, and then 3) combine those line-item estimates into a bottom-level estimate. For most moderately-sized projects, this estimation effort will probably include the creation of a basic design and architecture. For larger projects, the design and architecture will have to be completed before the estimate can be attempted. You have to know _what_ is being built and _how_ it's being built (at least to some extent) before you can start to figure out how long it will take.

There are many different formal estimation methods available. The one I prefer is pretty simple to put together and is called the [three-point estimation](https://en.wikipedia.org/wiki/Three-point_estimation) process. Basically, for each task in a work breakdown, this process has you make three estimates: the best-case estimate, the worst-case estimate, and the most-likely estimate. Those numbers are plugged into certain formulas, which will produce weighted average estimates and standard deviations for each task. Those estimates and deviations for all of the tasks are then plugged into a second set of formulas, and producing an overall estimate and standard deviation for the entire project. These formulas are pretty flexible: they can produce an upper-bound estimate for whatever confidence level you'd like.

The Wikipedia article on Three-Point Estimation provides all of the background and formulas you'll need to start running with this technique. It's a pretty quick read, and well worth the time it will take to familiarize yourself with it. As an example, I've put together a sample estimate for our hypothetical Project Foo, available here: [Software Project Estimation Template: Project Foo](https://docs.google.com/spreadsheets/d/1QEt9AWtXqIN-0O21MEzXL7Klg9UlI4z6hVmILZEtMHY/edit?usp=sharing).

TODO: Suggestion: Include the formulas and more discussion of the sample.

Moving beyond just the basic mechanics, though, there are a lot of additional best practices to try and implement when producing an estimate:

1. Always estimate in terms of person-effort-hours.
1. Learn about how poisonous the [anchoring effect](https://en.wikipedia.org/wiki/Anchoring) can be and avoid it at all costs. Ensure that the folks producing estimates haven't had their estimates influenced (intentionally or otherwise) by other people.
1. Getting estimates from more than one person is absolutely a great idea, but be sure to use some variant of [Planning Poker](https://en.wikipedia.org/wiki/Planning_poker) to ensure that each estimate is independent.
1. Ask yourself: "How long would this task take the best overall engineer in our company to do well, assuming all the stars align and she doesn't run into any unforeseen problems?" That's your best-case estimate.
1. Ask yourself: "What is likely to go sideways in the middle of working on this? Which library or tool is going to have a bug that has to be worked around and how long would that take one of our junior engineers to solve?" Feed that kind of thinking into your worst-case estimate.
1. As a general rule of thumb, your worst case estimate should be least twice what your most-likely estimate is. If they aren't, go talk with someone more pessimistic than yourself about what might go wrong.
1. If you haven't broken your tasks down into about 4-hour chunks, you probably haven't thought hard enough about everything that needs to be done. This is in no way a hard-and-fast rule, but it's a very good mindset to be in.
1. There's an old maxim that "the last 10% of the work takes 90% of the time." Think about why that is, and make sure your estimate includes the kind of work that appears in that last 10% of every project: documentation, release management, etc.
1. Include a chunk of time to account for the number of defects you expect to find as you start internal testing and how long it might take to fix those.
1. Will the folks working on the project be learning new tools or technologies as part of it? If so, that always takes longer than people wish it did. Be sure to account for that learning curve time!

Build a "Project Estimation Checklist" that includes those items above, and whatever other best practices you pick up as you get experience with this. Go through the checklist before submitting any estimates. Be sure to hold a retrospective after the project is complete and evaluate how the estimate turned out and what might be done to improve future estimates. Estimation is a skill that requires practice and training just like many others, so be thoughtful and deliberate about getting better at it.

Estimates don't come for free. I've found that just producing a solid work breakdown and estimates can take anywhere from a half-day to several days (depending on what design decisions need to be tracked down and finalized and how complex the project is). It's Christy's job to help Marty understand that good estimates will take a bit of time and effort to produce. On the other hand, off-the-cuff estimates are worth pretty much exactly what you paid for them (i.e. nothing). If you're being asked for estimates, be professional enough to produce them correctly.

## Where the Rubber Meets the Road

Once Christy has gone through all of the above, she'll have a detailed work breakdown with an overall estimate range that she can present to Marty. Marty is now in the hotseat on this: he has to convert that estimate range into a commitment. Depending on the industry and situation, I'd generally recommend he use the upper bound of the estimate's 90% prediction interval. Most companies can afford a one-in-ten miss rate (though it's simple enough to adjust the math to produce different confidence levels if desired). But that estimate is still just a starting point. How should Marty use it to produce a commitment?

The first thing Marty should do is have a conversation with Christy about all of the assumptions baked into her estimate. They need to ask, "what might cause us to miss this estimate?" That conversation should produce a list like the following:

1. The estimate assumes a certain staffing level. If the staffing situation changes, the estimate will need to be reworked to cope with those changes.
2. Every time one of the team members on the project is unexpectedly pulled off of it to work on something else, the delivery date moves out by at least that many person-hours.
3. The estimate assumes a certain set of requirements. If those requirements change, the estimate will need to be reworked to cope with those changes.

Also baked into the estimate is the assumption that it's complete and correct. However, project estimation is a hard skill and Marty needs to assess how good at it Christy actually is. If this isn't the first estimate that Christy has produced, there will be historical data that Marty can use to help in his assessment. Ultimately, Marty needs to boil that assessment down into a "buffer percentage". If this is Christy's first formal estimate, I'd probably recommend Marty add a 50% buffer to it. It probably also makes sense to ensure that her first project is either relatively small, or to break it up into phases and just estimate the first phase for now.

Marty can now take all of this information and produce a committed delivery date that incorporates the estimate, buffer, vacation time, expected sick time, and non-project time together. He'll also want to ensure that the requirements, staffing, estimate, and commitment are recorded somewhere fairly public that has change-tracking, like a wiki. It will be important to update this public record as things change, to help communicate and memorialize those changes.

## Estimates are Hard, Let's Go Agile!

Have you read through the [Agile Manifesto](http://agilemanifesto.org/)? Did you read through their [Twelve Principles of Agile Software](http://agilemanifesto.org/principles.html), too? If you haven't, go do that now. Even if you already have, it's always worth a re-read, so go read through them again anyways.

Agile makes things better. It really does. The problem with "going Agile" for Christy and most other coders, though, is that it isn't their call. Adopting any process – even an Agile one... no, **especially** an Agile one – requires commitment starting at the _top_ of an organization and continuing all the way down to the developers. Much as she might like to, Christy can't just tell Marty that "her team is adopting Scrum for all projects going forward." In my experience, though, that's exactly what folks like Christy try to do. Heck, I tried to pull that once earlier in my career. (Spoiler: It didn't go well.)

Please! Go start a conversation with the Martys in your life about how much better things would be if the business adopted a commitment to Agile principles and about how the business should switch to a particular Agile process. But recognize that for what it is: a recommendation that you're making from the bottom of the org chart, in the hopes that your executive team will understand what it is you're proposing, and agree to it.

And if you're a Marty, recognize that a switch to Agile needs to happen way above the first-line manager level. If your boss, and their boss, and their boss, etc. don't understand what it is your team is doing and how it will play out, things will end badly. This can be tricky given how much of an industry buzzword Agile is these days. There are a lot of organizations out there where management mandates that things have to be _called_ agile, but are completely unwilling to accept the business process changes that Agile actually calls for. If you find yourself trying to both "be Agile" and also produce detailed project plans six months out... my condolences. It's a tough position to be in. Open up a conversation about it upline, but try to avoid tilting at any windmills. Sometimes it's better to just roll your eyes and accept that you still live in a waterfall world.

Ultimately, Agile processes don't make sense for every business. And even for businesses where it _would_ make sense, it might be politically impossible to switch. That's really not the end of the world: embrace whatever process your business does have and get **good** at working within the process. Be a professional.

## Embrace the Uncertainty

> "Have no fear of perfection – you'll never reach it." —Salvador Dali

The most important thing for coders, project managers, executives, etc. to understand and agree on is that estimates are uncertain. They're hard. The world is an unpredictable place and we all have to cope with that. Here are a couple of facts that everyone involved in requesting, producing, or relying on software project estimates should be familiar with:

1. There is no hard evidence yet that engineers' 90% confidence effort prediction intervals will be correct more than 60-70% of the time. <a id="ref-1-source"><sup>[[1]](#ref-1-target)</sup></a>
    * This indicates that many estimates have overly optimistic worst-case estimates for many tasks and fail to account for some tasks completely.
2. Software projects are usually underestimated, and the overrun is on average around 30%. <a id="ref-2-source"><sup>[[2]](#ref-2-target)</sup></a>
    * There are two components here: individual tasks that are underestimated and tasks that never make it into the estimate to begin with.

So... estimates are useful, but have definite limitations. Remember: estimates are not the same as commitments. Your project management and business processes have to account for reality. That's only a problem if you try to pretend that it isn't.

<a id="ref-1-target>[[1]](#ref-1-source)</a> Jørgensen, Magne, Karl Teigen, and Kjetil Moløkken-Østvold. "[Better sure than safe? Over-confidence in judgement based software development effort prediction intervals.](https://www.simula.no/publications/better-sure-safe-overconfidence-judgment-based-software-development-effort-prediction)" *Journal of Systems and Software*, February 2004.

<a id="ref-2-target>[[2]](#ref-2-source)</a> Jørgensen, Magne. "[What We Do and Don’t Know about Software Development Effort Estimation](https://www.simula.no/publications/what-we-do-and-dont-know-about-software-development-effort-estimation)" *IEEE Software* 31, no. 2 (2014): 37-40.


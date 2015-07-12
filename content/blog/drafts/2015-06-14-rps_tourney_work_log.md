--- 
title: "RPS Tourney Work Log"
kind: article
created_at: 2015/06/14
tags: [coding]
excerpt: "TODO"
---

TODO: This needs a real title.

This one Markdown file is the most interesting experiment I've ever run: [RPS Tourney: Work Log](https://github.com/karlmdavis/rps-tourney/blob/master/dev/work-log.md). It now contains a year and a half of time tracking data for my incredibly silly side project (an online Rock Paper Scissors game). My goal has been to work on this project every single day, even if it's only for a few minutes.

I put together a simple little Python script that parses the data into a somewhat more structured CSV file. I then dumped those rows into a `XX` spreadsheet that I put together to do some simple analysis of the data. Even just that simple analysis provides a whole wealth of insights into the project's history:

TODO: just use this table to list some of the basic statistics

<table>
	<thead>
		<tr><th></th></tr>
	</thead>
	<tbody>
	</tbody>
</table>

Enough background... let's look at the data!

TODO: Finish the parsing Python script.

```

```


NOTE: Attempting a pivot here-- new angle after this point


# You Don't Even Know How Wrong You Are (With Estimates)

As a general rule, we coders are almost universally bad at producing estimates. We are so bad at this that we've invented entire workflows and industries around just how unlikely it is that any of us will be able to produce estimates. But note my wording very carefully here: we're bad at **producing** estimates. I didn't say we were bad at producing *accurate* estimates—just that we have a hard time giving them in the first place.

## The Cycle of Estimation Despair

I think the following process has played out for almost every coder ever these days:

TODO: maybe try to rewrite this as mostly dialogue, e.g. a play script.

1. Marty the Manager wants a delivery date commitment, but words it like this: "We need an estimate for when Project Foo will be completed."
2. Christy the Coder, not understanding the distinction, goes off and produces an estimate using some sort of emotional dartboard, e.g. "This project *feels* like a three-week effort."
3. Marty the Manager, not understanding the lack of rigor involved in how the estimate was produced, and also not noticing the difference between what he asked for and what he wanted goes off and bids the work and/or makes a commitment to their bosses about when the project is done.
4. At the end of the three weeks, both Christy and Marty are completely flummoxed when the project isn't done. Christy will insist that "it was just an estimate, not a commitment!" and Marty will yell about "how come you coders can't estimate things accurately!"
5. Christy, after getting burned by this experience (maybe several times), will go off and become an ardent supporter of Agile: which she understands to mean "I don't have to produce estimates anymore and Marty can't make me."
6. Marty, understanding Agile to mean "Christy needs to work faster," will still insist on some form of deadlines, and the business will get stuck in a neverending tug of war on this, forever and ever. The end.

There are two really striking things about this entire mess: the miscommunication on both sides, and how lousy a job we coders all do on producing real estimates. Between these two problems, it's no wonder how much stress we all all suffer from project planning and the blame game of missed deadlines. 

The miscommunication is poisonous. Because we can't understand and agree on what the words "estimates" and "commitments" mean and what the differences between them are, we all quickly learn that we can't trust each other in these kinds of conversations. Because we can't understand and agree on what Agile means, every attempt to analyse how well it's working in a particular situation quickly devolves into a hopeless death spiral of [No true Scotsman](https://en.wikipedia.org/wiki/No_true_Scotsman) arguments: "Project Foo would have been fine, if only the team had **really** embraced Agile." If Christy and Marty want to solve their problems, they're going to have to sit down and work through these communication issues first.

## Breaking the Cycle

From here on out, I'm going to use the following definitions:

<dl>
	<dt>Estimate</dt>
	<dd>A probability distribution of when a given task or project is likely to complete.</dd>

	<dt>Commitment</dt>
	<dd>A date given to the business or customer, by which a given task or project must be complete.</dd>

	<dt>Agile</dt>
	<dd>A set of principles, not processes. Read them!: [Manifesto for Agile Software Development](http://agilemanifesto.org/)</dd>
</dl>

While commitments almost always require estimates before they can be made, an estimate is in no way the same thing as a commitment. A commitment is most typically a single point in time. For example, Marty might tell his boss that Project Foo will be delivered no later than June 30.

An estimate is best thought of as a _range_ of effort. For example: Christy might tell Marty that Project Foo has a 95% chance of being complete within 750 engineer-hours, but also has an 80% chance of being complete within 450 person-hours. Another way of framing that is if Christy and her team were asked to deliver projects similar in size and shape to Project Foo, four out of times those projects would each complete in less than 450 person-hours, and the fifth project would be complete in less than 750 person-hours 95 times out of 100. Note that there isn't necessarily a linear relationship here: 10% more certainty may add far more than just 10% more person-hours. Estimates are a tool for expressing the uncertainties and variablilities inherent in every project, and those challenges vary wildly from one project to another.

Note also that estimates are not framed in terms of days, or weeks, or other such units of measure. It is up to Marty and the business to decide how many people to have working on Project Foo and to decide how much of their time will be spent on it. If they're smart, they'll ensure that the team is "fenced off" such that they're only working on this one project, as multitasking will slow them down, increasing the number of person-hours needed. Hopefully, Marty and Christy will also discuss the following:

* Different engineers will be faster or slower than others, with more experienced engineers generally being faster. Was Christy sizing the tasks based on how long it'd take _her_ to do them, or how long it'd take junior coder Joe to do them?
* There are probably dependencies between various parts of the project, such that _A_ must be completed before _B_, and such. It's probably not a great idea to have 15 engineers assigned to the project if 14 of them will be blocked most of the time, waiting for other parts to be ready.
* Adding extra bodies to the project will increase the amount of communication needed within the project team: emails, hallway conversations, meetings, etc. Past a certain number of team members, this communication overhead will eat more time than it saves.

It's ultimately up to Marty to manage all of this, and to make deadline commitments based on his appetite for risk. This is really a political decision: can Marty (or the business) afford to miss their commitment on Project Foo? What is Project Foo's priority relative to the other things that need to get done and which folks can be spared to work on it? For really important deadlines, I'd encourage Marty to go with the 95% estimate, but for most projects, an 80% or 90% estimate is probably fine.

At the same time, though, it's Christy's job to discuss all of this with Marty and to help him understand how things might play out, based on the decisions that are made. Communication is a two-way street, and both parties are responsible for ensuring that they're on the same page.

## Where Do Estimates Come From?

Communication is key, but Christy still needs to leverage something more concrete than her intuition and feelings when producing estimates. Those are good enough for very small tasks of a day or so but for anything substantial Christy needs to: produce a work breakdown, estimate all of the parts, and then combine those line-item estimates into a top-level estimate. For most moderately-sized projects, this estimation effort will probably include the creation of a basic design and architecture. For larger projects, the design and architecture will have to be completed before the estimate can be attempted. You have to know _what_ is being built and _how_ it's being built before you can start to figure out how long it will take.

There are many different formal estimation methods available. The one I prefer is pretty simple to put together and is called the [three-point estimation](https://en.wikipedia.org/wiki/Three-point_estimation) process. Basically, for each task in a work breakdown, go through and make three estimates: the best-case estimate, the worst-case estimate, and the most likely estimate. Plug those numbers into some formulas, and you'll get back out a weighted average estimate and a standard deviation for it. Plug the estimates and deviations for all of the tasks into a different set of formulas, and you'll get an overall estimate and standard deviation for the project back out. These formulas are pretty flexible: they can produce an upper-bound estimate for whatever confidence level you'd like.

The Wikipedia article on Three-Point Estimation provides all of the background and formulas you'll need to start running with this technique. It's a pretty quick read, and well-worth the time it will take to familiarize yourself with it. As an example, I've put together a sample estimate for our hypothetical Project Foo. TODO: create a Google Docs template containing the most tasks and the formulas. You can use the sample as an estimation template for your own projects, if you'd like.

Estimates don't come for free. I've found that just producing a solid work breakdown and estimates can take anywhere from a half-day to several days, depending on what design decisions need to be tracked down and finalized and on how complex the project is. It's Christy's job to help Marty understand that good estimates will take a bit of time and effort to produce. On the other hand, off-the-cuff estimates are worth pretty much exactly what you paid for them (i.e. nothing). If you're being asked for estimates, be professional enough to produce them correctly.

## Why Don't We All Switch to Agile so Estimates Aren't Needed Anymore?

Okay, first of all: if you find yourself asking this question, you probably didn't really understand the definition of Agile that I included above. Agile is a set of principles, not a particular process. There _are_ processes specifically targeted at the Agile principles, though – Scrum, for example. It's entirely possible to genuinely adopt the Agile principles and still find yourself using a process that requires estimates.

That said, most Agile processes place much less of an emphasis on formal project management techniques such as estimates, deadlines, etc. And when those processes do require estimates, they're generally for much smaller chunks of work and favor flexibility instead of commitments. The problem with "going Agile" for Christy and most other coders, though, is that it isn't really their decision to do so or not. Adopting any process – even an Agile one... no, **especially** an Agile one – requires commitment starting at the _top_ of an organization, all the way down. Much as she might like to, Christy can't just tell Marty that "her team is adopting Scrum for all projects going forwards." In my experience, though, that's exactly what folks like Christy try to do. Heck, I tried to pull that once earlier in my career. It doesn't go well.

Please! Go start a conversation with the Marty's in your life about how much better things would be if the business adopted a commitment to Agile principles and about how the business should switch to a particular Agile process. But recognize that for what it is: a recommendation that you're trying to make from the front lines, in the hopes that your executive team will understand what it is you'r proposing, and agree to it.

And if you're a Marty, recognize that a switch to Agile needs to happen way above the first-line manager level. If your boss, and their boss, and their boss, etc. don't understand what it is you're doing and how it will play out, things will end badly. And we've already talked about the biggest and most likely red flag you'll see that indicates you failed to get them on board: if you find them asking you to provide a commitment for some new feature or new product that's six months out... you're in trouble.

Ultimately, Agile processes don't make sense for every business. And even for businesses where it _would_ make sense, it might be politically infeasible to switch. That's really not the end of the world: embrace the waterfall and get **good** at working the process. Be a professional.

TODO: tie in my RPS estimate data somehow


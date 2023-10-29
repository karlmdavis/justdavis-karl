---
title: "Baltimore DevOpsDays 2017"
layout: post
date: 2017/03/07
categories: 
description: "Notes and live blog of this inaugural two-day event here in Baltimore."
---

[DevOpsDays Baltimore 2017](https://www.devopsdays.org/events/2017-baltimore/welcome/): This inaugural two-day event is being held in Baltimore on March 7th and 8th of 2017 at the Baltimore Institute of Marine & Environmental Technology (IMET), an absolutely bright and gorgeous venue.

This post contains my notes and live-blog for both days of the event. Are you also attending? Join the conversation on Slack by [signing up for the Baltimore Tech Team](http://slack.baltimoretech.org/) and joining the `#devopsdays` channel.

## Tuesday 9am Nathan Keynote
* Note: I came in about 75% of the way through this talk.
* We are all the DevOps experts in our companies.
* Invite everyone to postmortem.
* Run in-conferences at your company.

## Tuesday 10am ThoughtWorks CI Talk
* Most folks here know about and are using CI.
* CI requires:
    * At least daily integration into master, per Jez.
    * Commit everything.
    * Build every commit.
    * Keep it fast.
    * Have self testing.
    * Show visible failures.
    * Fix failures immediately.
* Why do we love CI?
    * Avoid merge conflicts. Amortized integration pain. Frequency reduces difficulty.
    * Fast feedback.
    * Reduce risks.
    * Collective ownership.
* History
    * CI started in the 90S.
    * Cruise Control was first CI server in 2001.
* CI relationship status: it's complicated.
    * 68% folks check-in daily, self reported.
    * Gartner: 40% orgs practicing CI, 40% have no plans to.
* "CI Theatre": pretending to do CI, without actually doing it.
    * How regularly are you checking into master?
    * How long-lived are your branches?
    * Just having a CI server isn't enough!
* But who cares? Maybe half-measures are still "good enough" or delivering plenty of value.
    * If your branches are living more than a day, you are missing out on collective ownership.
    * Code reviews get painful or impossible, as commit size goes up.
* Personal quesion: how can you do code reviews if you're checking in every day?
* How to save your CI now!
    * Commit more often. More than once a day! You might be surprised at the results if you try.
    * Automate, automate, automate.
    * Trunk-based development.
        * In the survey they did, those teams that weren't doing this had more problems than those that were. Strong correlation.

## Tuesday 10:45 DevOps Improv

* Main Presenter: Victoria, Blackstone Consulting
* Also, Shawn: Improv comedy changed the way he interacted with folks every day.
* RPS Tournament: **Paul** crushed all of the competition!
* Why play RPS? It's all about supporting each other.
* Room survey:
    * 60% folks know they can change the culture in their org.
    * 40% aren't sure, but are interested in learning how.
    * 1 guy was a bit lost, and didn't know how to change the culture but wanted to.
    * No one thought it couldn't be done. 

## Tuesday 11am Troubleshooting
* Presenter: @papa_fire on Twitter
* Why troubleshooting?
    * Seems to be a fading skill.
    * Used to be, when in doubt: reboot.
    * Now, treat all your servers as cattle: put down any sick animals.
* Problem solving: ability to fix things you know nothing about.
* Systems are complex. Murphy's Law rules. Someone is always watching; users always notice when things break.
* Troubleshooting is more than wishful thinking or magic. It's a process.
* Where to begin?
    1. Replicate the problem.
    2. Isolate the problem.
    3. ... ?
    4. Fix the problem.
* Word of the Day: Understanding
* "We can't support 100s req/min. We need to scale better!"
    * Think clearly: That's 2 req/sec: you don't have a scaling problem; you have a performance problem.
* 404: What does it mean to you and your business?
    * If you're Amazon, it means lost sales.
    * If you're the Wall Street Journal, it means lost ad revenue.
* Every technical decision powers a business need.
* Is there a lesser of two evils?
* Sometimes breaking things actually fixes things.
    * 80% now > 100% later.
* Incremental improvements are great.
* Anatomy of a problem:
    * It's more important to fix things to "working acceptably" than to get them to "fixed".
* What not to do...
    * Don't assume; understand the problem before running in.
    * Be kind. Crisis can bring out the worst in folks; avoid that.
    * Don't cling to mistakes, just because you made them. Avoid defensiveness.
    * Solve the problem; don't feed your ago.
    * Ask for help!
* Three troubleshooting tools:
    1. Logging
        * Should be actionable, concise, parseable. It usually isn't.
    2. Monitoring
        * Should be all-inclusive, business-first, and correlatable.
        * Trouble tickets never provide enough detail.
        * Anecdote: Got a call that revenue was down, so something must be wrong. Performance was fine, DB load was normal, but credit card declines were way up. Next day, someone lets them know that they were in negotiations with AmEx and couldn't use them in the meantime.
    3. Profiling
* Troubleshooting is... educational, iterative, frustrating, rewarding.

## Tuesday 11:30 Culture
* Presenter: Jeff Gallimore (@jgallimore), from Excella Consulting
* "Culture eats strategy for breakfast.", Peter Drucker
* In 2014, "culture" was Merriam Webster's word of the year, based on online searches.
* CALMS: Culture, Automation, Lean, Measurement, and Sharing
* Culture is hard to descibe. Hard to measure. Hard to change.
    * If you can't measure it, you can't tell if you've actually changed it.
* State of DevOps 2016 Report findings:
    * 200x more frequent deploys
    * (missed the rest)
* 2015 report determined that culture rpedicts both IT performance and organizational performance.
    * Also predicts burnout.
    * Culture leads to more successful orgs and happier employees.
* What is culture?
    * Westrum's Culture Typology: Pathological (power oriented), Bureaucratic (rule oriented), Generative (performance oriented)
    * "Having a Just Culture means that you're making effort to balance safety and accountability.", John Allspaw
        * Blamelessness isn't about a lack of accountability, but about safety: making sure that it's safe for folks to actually learn from mistakes.
        * Embrace mistakes as opportunities to learn & improve. Mistakes are inevitable.
        * A culture of fear (e.g. criminal prosecution of air traffic controllers) will reduce visibility into problems: people just won't report the problems that are happening.
        * Psychological safety: "If I make a mistake on our team, it's not held against me." Does the people in your org agree with this statement? Strongly predictive.
        * A Google study found that psych safety was far & away the most important dynamic that set apart high-performing teams. See also Edmondson, A. 1999 "Psych Safety and Learning Behavior in Work Teams" (p. 9)
    * Safety, Learning, Performance: all connected.
* It's important to assess your culture.
    * Jez & others started DORA, which provides a DevOps assessment service (via surveys and analysis).
        * Not free. Alternative: look at Nicole Forsgren's study and leverage the same questions.
* Education: knowing is half the battle. Ensure that folks understand why culture is important.
    * Speak to the heard and the heart.
        * Head: Winning IT and org performance. Present the science.
        * Heart: Read John Willis' "Karojisatsu" post on the IT Revolution blog. It's about burnout-related suicide. Culture impacts burnout.
* Change your mindset.
    * New assumptions:
        1. People do not come to work to do a bad job.
        2. Everyone is doing the best job they can given the information they have at the time.
    * Shift from "who?" to "why?".
        * Last week's AWS S3 outage postmortem provides a positive example on how to handle this.
            * Why did the system allow this typo?
            * Why did a simple typo cause such a massive problem?
* Model the behavior.
    1. Frame work as learning problems, as opposed to execution problems.
    2. Acknowledge your own fallability.
    3. Model curiosity by asking a lot of questions.
* If this behavior isn't already prevalent in your org, you're taking a risk by adopting it. But you'll be a hero to your coworkers!
* Deming quote: "... The workers are handicapped by the system, and the system belongs to the management."
* Management's role is critical in culture.
    * Change will move as fast as the leader.
    * They control consequences and rewards.
* Culture matters! It affects each of us. We each have deep personal experiences with it.
* We each have power for change.

## Tuesday 1300 Ignite Talks

### Getting Away From It All, Leon Adato
* Triple Dog Dare: get away from your devices.
* Over 2/3 of all Americans own a smartphone.
* People feel worse about their lives, after going on Facebook.
* Belongs to a secret society of "wingnuts": Jewish folks who take a Sabbath every week.
* Have a plan to be flexible and adjust, but take time to step away from digital devices.
* Don't make a show of it and tell people -- just do it.
* Build a habit to disconnect regularly.
* Build a plan to come back online: don't spend all your time preparing for it or recovering from it.
* Fuck device notifications.
* On-call presents a particular challenge. Try to be generous with your teammates in making _their_ on-calls as easy and flexible as possible.

### The Flat Track to DevOps, Renee Lung
* "How Roller Derby Relates to DevOps and Vice-Versa"
* Roller Derby strategies have changed a bunch over the last 20 years. Now, collaboration is crucial.
* Working at Pager Duty, this rings trye there, too.
* Moving fast only adds to the expectation that we're going to move faster.
* At Pager Duty, we believe that the fastest way to improve software quality is to make the engineers that wrote the code support it.
* Being on-call is very similar to being on-point in Roller Derby. Your team relies on you.
* But being a team member means that there's a lot of jobs to do, and you can't do them all yourself.
* Sometimes the best thing you can do as a teammate is to ask for help.
* DevOps and Roller Derby both have cultures that bring people together.
* When folks work together, you get more than better business outcomes: you also get better relationships.

### Alan Kraft, Hacking the A3
* A3 is a really powerful tool for DevOps, particularly when customized for a team.
* See Ben Rockwood's DevOpDays 2016 talk, "The Power of A3 in Action."
* Personal Note: I have no clue what A3 is. Should I?
    * Google says it's a problem solving and continuous improvement approach.
* Plan --> Do --> Act --> Study --> (repeat)
* Pitfalls:
    * Don't make big A3s; break them down.
    * "A good A3 is a reflection of the dialog that created it."
* Pragmatism: What's correct is what works. Design Thinking, yo'.
* Read John Alspaw's blog post on dropping root cause analysis.
* Looking to pursue next:
    * What flows into an A3? Trying new things.
    * Experimenting with what flows out of A3.

### Elias Senter, Best Practices for IT Management: Investment-Based Budgeting
* Or "How I learned to stop worrying and love the budget."
* Investment-Based Budgeting: How to trick your accountant into giving you the money you need.
* If you're not a manager, you're a target to lose your budget. Particularly in federal government.
* Traditional problems: playing games, micromanagement, _you_ just do what's best for the business, missed opportunities due to budget cuts, black hole syndrome (lack of perceived value).
* Traditional budgeting process doesn't work.
* Chargebacks don't fix the problem. Taxation without representation.
* Fresh perspective: internal entrepreneurship.
* Don't budget for your costs, budget for the value you're providing.
* Break budgets down by the valued services you're providing. When asked to cut, this turns the conversation into one about which services can be cut.

### How to be Average, Peter Burkholder
* Innovation Specialist at GSA/18F. @pburkholder
* "How to be awesome?" is the wrong question. If you think you're awesome, you're probably not. See: Dunning-Kruger Effect. "How to be average?" is a better question.
* Awesome is less interesting: better to be average at the things that really matter.
* Average DevOps people rely on processes and practices that work, rather than individual ability.
* Judges on parole board grant petitions more early in the morning, and more right after lunch. We're all subject to human limitiations!
* If you think you're an above-average manager, you're not. That's okay! Get feedback to find your weaknesses and address them.
* Diversify yourself: bring DevOps to other arenas, bring your team to other groups.

## Open Spaces this Afternoon
* Ground Rules:
    * Each table has a post-it pad. Except for the tables they knew would only have bad ideas.
    * Three open spaces each on this level and the one above.
    * It will be chaotic at first. Embrace that.
    * What do you want to talk about? Write it down!
    * Give a 1 or 2 sentence pitch for each idea.
    * Put the pitches up on the wall behind us. "The Marketplace of Ideas."
    * Once all ideas are collected, the real chaos begins.
    * Each person gets three votes for their favorite ideas. Only vote for things if you care. You can spread your votes around however you'd like.
    * Put a dot on each thing for each vote you're giving it.
    * Once everyone has voted, we'll magically organize them and put the highest-voted ideas into open spaces.
    * The open spaces will be numbered. Six spaces, three time slots.
    * You don't have to be an expert in the thing you want to talk about. Just be passionate about it!
    * All topics are great, but not all topics will have enough people passionate about it.
    * One Law: If you go to a discussion and it's not working for you, you must leave it. We must all be asholes, if needed. But don't be an asshole: actually be nice about it!
    * Legalese: We're here to learn from each other, and need to all feel safe. Friend-Disclosure Agreement: keep what you hear to yourself.

## Wednesday 0915, The Rainbow of Death, Mike Bland
* Even at Google where things were awesome, few devs wrote tests.
    * If things are so awesome without tests, how could the lack of tests be hurting?
* Then, complexity started to explode, as the company continued to grow.
    * GWS (main page search) tech lead Bharat Mediratta believed automated testing would help.
    * After enforcing test coverage policies for a while, the GWS team became one of the most productive in the company.
    * But this success story wasn't being adopted by other teams.
* The Rainbow of Death: Intervene, Validate, Inform, Inspire, Mentor, Empower
    * As ideas cross this spectrum, they move from being dependent on experts to taking on a an independent life of their own.
* Driving the adoption of a testing culture was a 20% project for many folks: the Testing Grouplet.
* Lewin's Social Change Model: Unfreeze, Change, Refreeze. A tension betwen driving forces and restraining forces.
* Testing was way harder than it needed to be at Google: there just hadn't been enough investment to make it easier. These problems were attacked systematically.
    * Training: new employee training, tech talks, free books.
    * Test data: small, medium, large.
    * Tools.
* Hilarious (and yet very effective) training idea: Testing on the Toilet.
    * Periodical that got published on the backs of stall doors.
* Created a "Test Certified" certification, with mentorship and support to encourage folks to get it.
* Also pitched and put together the "Test Mercenaries" team that could help out other teams as-needed get projects to Test Certified.
* The Test Certified project also provided teams with test info radiators.
* Organized "Fixit" events to attack low-hanging problems that weren't getting addressed through the normal prioritization mechanisms.
    * The Blaze (open sourced as Basil) cloud testing tool came out of these events.
* Set a goal: getting every team to Test Certified Level 3.
    * This helped unify the testing efforts.
* These lessons apply to all organizations, not just Google. Like everyone else, they're just made up of humans.
* Convincing folks to adopt improved practices is, and always will be, hard.
    * Metrics and arguments don't change mind. Experiences do.
    * The problem that you want to solve may not be the problem that you have to solve first.
* Why "The Rainbow of Death"?
    * Because you've got to kill your ego.
    * Consider the self-portrait of David & Goliath, where the artist portrays himself as Goliath: we're our own biggest enemy.
    * But you're never alone! There are always other folks looking to improve things. Join forces.

## Wednesday 9:55a, The Transversal Delivery Pipeline, Mike Nescot, Nick Grace
* We'll be talking about the transformations in the areas of data science, IoT, etc.
* These transformations enable opportunities: intelligent applications, bots, multimodal systems, and others.
* Pipelines are a key concept for DevOps. You can contrast them with silos.
* Back in the bad old days, there were no pipelines; everything was done in production.
* Data science need pipelines, too: continuous delivery for the source data sets and resulting analysis produced by your data science.
* Editorial: so far, has just been listing lots of various machine learning models, algorithms, and tools.
* Data science is really just a type of application development. It's starting to need and converge with DevOps: data science teams need and have ops teams.
    * On the flip side: data science can help improve general DevOps.
* Bots used to be a dirty word. But in the last couple of years, they've started to come into their own.
    * Slack dots to aid DevOps workflows.
    * Conversational interfaces (e.g. Alexa, Siri).
    * This shift has been driven by advances in AI, machine learning, and NLP.
    * These new bots face all of the same challenges that more typical applicatiosn do.
    * But they also face some unique challenges: the Uncanny Valley.
* Bot applications:
    * Question Answering
    * Recommendations
    * Summarizations
    * Human Augmentation
    * Sentiment Analysis
* NLP Challenges
    * complexity
    * context
    * ambiguity
    * slang
    * sarcasm
* In physical product development, orgs will often also develop a "virtual prototype" of the product, that can be used in continuous development pipelines, particularly for testing.
    * VR advances may have some bearing here: you can now also test products' aesthetics.
    * Drone-mounted cameras and sensors can be used in construction to measure and monitor buildings while under construction.

## Wednesday 10:45a, Don't Mind the Gap: How to DevOps in an Airgapped World, Galen Emery
* A lot of DevOps tools can't cope with common security restrictions:
    * Lack of root on dev systems.
    * Lack of root on production systems.
    * Authenticated proxies.
* Everything is code. Everything.
* Principle: go from low-security to high-security environment. Never the other direction.
* Assume your systems won't have access to the internet.
    * Most tooling isn't down with this.
    * Tricky: make sure that development systems match production. So: test systems shouldn't have internet access, either.
* Protect the **data**, not the infrastructure.
    * Again: everything is code. Keep the infra in source control.
* Have a single point of entry for everything moving from development to production.
    * Automate this workstation, too, because you'll need to have a similar system and process in dev test.
* Example workstation setup:
    * ChefDK
    * FTP server that hosts artifacts, etc. to bootstrap the production setup.
    * Chef Zero does the work here.
* Dependencies further complicate things.
    * Do you want to try and mirror rubygems.org (or Maven central)? Nope! Just mirror the artifacts in there that you'll need. See: Artifactory.
* Use the workstation and artifact repository to setup your configuration management.
    * Use Chef SSH to get started. Bootstrap your Chef server using it.
* Watch out fo things that assume internet access:
    * Remove rubygems from your sources. Add your artifact store.
    * Set chef to use an internal supermarket via berksfile. Artifactory again.
    * Even if you have a proxy, it's often easier to get things working without _any_ internet access than it is to make all the bits and pieces support the proxy.
    * Getting a proxy working will also require poking a **lot** of holes: rubygems, Slack, GitHub, etc.
* Repeat for importance: Do this in Dev.
    * Do not wait for prod to test that things work without internet access.
* Identify where you're assuming [ed: incurring] risk
    * If users can SSH into production, there's your risk.
* Imagine this Scenario
    * Nobody ever logs into production
    * All changes flow through a pipeline that tracks changes.
* As an individual developer, though, you should have access to the tools you need.
    * Devs should be able to get to Slack, GH, etc.
    * Work with security, not against them. They're a critical part of your business.
    * Pitch this as a security win: by bringing them into the process and testing things earlier, security benefits, too.
* How often do we update our packages?
    * This has to be part of the development pipeline.
* Where are the gates?
    * Code reviews are critical.
    * Also consider a second review by the business owner prior to production delivery.
* What are the metrics?
    * Velocity: how fast we ship.
    * Efficiency: how good we are at shipping. Are we seeing problems in production or are they being caugt in dev?
    * Risk: how long does it take us to fix problems?
* Editorial: this was a great talk.

## Wednesday 11:25a, Making Your Product Manager Production, Clinton Wolfe
* Let's talk about integrating the product/project teams into DevOps.
* Some assumptions about your org first:
    * You've adopted Agile (or have at least tried to).
    * Your product team is now run by executives. Non-technical folks.
    * You have some friction between engineering and product.
* The Bad Old Days (circa 1990s)
    * Waterfall everywhere: cycle times measured in years,
* Now
    * Agile brought down the product --> engineering cycle times.
    * Continuous testing brought down the cycle time within engineering.
    * DevOps brought down the cycle time between engineering and ops.
    * But there's still a barrier between ops and product.
        * "Why would we need log aggregation?" Seems wasteful.
* Are POs/PMs terrible/horrible people dedicated to making everyone miserable?
    * No... (aside from some exceptions). This talk is about empathy!
* Meet Your PO
    * POs are the bridge to the customer. They're engineers' ally!
    * Good POs defend the team to the customer.
    * Often a transitional role: good ones get promoted, bad ones get fired.
* Meet your PM
    * Often come from a quantitative/financial background.
    * "Plan the work, work the plan."
    * PMP certification: still really focused on a waterfall approach.
    * Often on their **first** software project.
        * This will be a real learning process for them. Very different world.
    * Stressed out.
* Conflict point: common language.
    * They don't speak tech. Leads to both sides feeling misunderstood.
* Being non-technical provides a lot of value: POs speak "customer", and can drive the revenue that success is measured by.
    * POs have to have negotiation skills, learn compromise, develop people skills (patience, listening, empathy).
* Editorial: this is also a great talk. This guy is really hammering home the importance of empathy.
* Vocabulary is critical and requires investment.
    * E.g. ensure that POs know what a "load balancer" is.
    * POs need to feel safe to ask questions.
* In bad orgs, engineering and product will have violent disagreements about whether uncommitted work happens (and whether it should).
* In healthy orgs:
    * Time for unplanned work.
        * Emergent Work: things that you didn't know that needed to be done until you get there.
            * Involving ops early can help prevent these.
        * Rework
            * Sometimes -- it turns out -- things just don't work right.
            * Upstream CI and automation can help prevent this.
        * Incident Management
            * "DevOps harder" to reduce these. Seriously!
    * Time for infrastructure tasks.
    * Track dependencies. Use the features that JIRA/whatever are handing you for this!
* PMs want firm estimates. This is a conflict point.
    * Orgs are **always** bad at agile estimation at first.
    * Not a fan of agile points: only one input, one output. Discards too much context and risk data.
        * Use three-point estimation instead. See "Software Estimation", Steve McConnell, p120.
        * Editorial: I strongly agree! But haven't seen anyone integrate this well into Agile sprints, yet.
        * Produces a measure of risk, which helps determine which stories need research spikes to de-risk them. PMs **need** to want and consider these risk measures.
* Conflict point: Ops needs.
    * "The customer isn't asking for monitoring. We don't need it. ... Why do we keep getting surprised by all of these outages?"
    * Have a culture where everyone, particularly ops, can add stories to the backlog.
    * Software that isn't deployed and running has **no** value.
    * Make sure that folks understand what the SLAs are, how they impact revenue, and what's needed to actually meet them.
* Cross-Functional Teams
    * Works well in many places, but can leave ops folks feeling overwhelmed. If each team only has one ops specialist, that person is going to have a bad time.
    * Consider "Guilds" instead. Look up what ING did, with their service team re-orgs where everyone had to reapply for their jobs.
* @clintoncwolfe

## Wednesday Ignite Talks

### Deploying 30 Times a Day, and Making Sure Everything Stays 200 OK, Eric Sigler
* Right metric: Deploys per day per engineer.
* What do you call a group of crows? A murder.
    * What do you call a group of developers? A merge conflict.
* 100% test coverage is an anti-pattern.

### ~~~Putting~~~ Convincing the Ops in DevOps, Jamie Jones
* @jbjonesjr, GitHub
* "The Phoenix Project" book got its... fifth shoutout of the day?
* There's a new JS framework every fucking day, but Ops folks are still using the same Perl, Bash, etc. scripts that they've used for decades.
* Are you looking to play with fun technologies? Or are you committed to delivering successful business outcomes?
    * Focus on outcomes, not tools.
* Empathy
* Gates/regulations/etc. can't just be problems for Ops folks. Engineering has to take some ownership.

### Third-Wave DevOps: What We Can Lern from Coffee, Jason Yee
* After Boston Tea Party, USA switched from tea to coffee.
* Not a fan of Folgers.
* Starbucks coffee is modeled after Italian-style coffee.
* Starbucks values people: from baristas to farmers. Fair trade.
* Third-wave of coffee: started roasting and brewing to highligt best parts of beans.
* Similar story with DevOps. Right now we're just at the second wave, and starting to focus on empathy and commonalities between Ops and Engineering.
* Need to move ot third-wave DevOps: get away from the novelty of tools, etc. and focus on the business outcomes that we're all trying to achieve.

### DevSecOpsNess: Adding the Business Dimension to DevOps, Tanusree McCabe
* How do you know that what you're building actually provides value? Product groups are wrong sometimes, too.
* Everyone should take ownership of this problem by adding business skills/dimensions to your skills/outlook.
* Challenge processes. Challenge security assumptions.
* Some questions to consider:
    * What's the purpose of our app/system?
    * How do your requirements align to your business strategy?
    * What's the Total Cost of Ownership for this_thing?
    * What are the real/perceived business contraints?

### DevOps: It's Just a Game, Tom Larrow
* Estimated that > 1B people play video games every day.
* Games can teach us how to fail, and how to fail fast.
    * Games are all about failure.
    * "Games put our brains in a challenge mindset."
* How do we bring this challenge mindset to DevOps? Embrace failure and gamify development.
    * Games and DevOps must consider the difficulty curve: tough enough to be challenging (and provide value!) but not disheartening.
* CI systems create safe spaces for failure.
* Avoid criticism. Instead, offer help.

## Wednesday 1:30p, Announcements
* DevOpsDays DC is coming up in July.
* The CFP and ticket sales for it just opened.

## Wednesday 1:30p, Open Spaces
* Jeff Gallimore mentioned that he can dig up links for a great success story on "automating compliance at USCIS". Might turn up in Google, too.

## Meet and Greet
* Sat next to Mat with the beard, Tuesday morning. Sysadmin lead that lives in Baltimore but works remotely. Uses Ansible, JIRA, and Jenkins. Mountain biker. Moved to area for wife's law school.
* Other side: two folks from NIH: Pranhti, a program manager, and (TODO) the deputy CIO.

## Brainstorming Open Space Ideas
* DevOps Glee Squad: Come cheer everyone up with awesome stories you've experienced where DevOps have saved the day!
* Golden Oldies: What great old tools do you still use that other folks seem to ignore because they're "so old?" Hashtag Kerberos4Lyfe!
* Extreme(ly Awesome) Feedback: Stop lights for build status, auto-aimed Nerf "executions" of whoever broke the build, silly hats for to indicate roles? What awesome things have you built or used in meat-space to help connect folks with the virtual DevOps world?
* Ouch, none of those ideas did well in voting. Most popular ideas were:
    * Disaster recovery for your career.
    * A3 Thinking
    * Agile Processes
    * Monitoring: Where to Start
    * DevOps in the Federal Government

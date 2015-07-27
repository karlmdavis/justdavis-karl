---
title: "What On Earth Was I Thinking?"
kind: article
publish: true
created_at: 2015/07/27
tags: [coding]
excerpt: "What on earth was I thinking, deciding to spend my free time building a Rock-Paper-Scissors game, of all things‽ Good question!"
---

For well over a year now, I've been spending a good bit of my evening and weekend time on the most absurd side project I could invent: [RPS Tourney](https://github.com/karlmdavis/rps-tourney). What on earth was I thinking, deciding to spend my free time building a Rock-Paper-Scissors game, of all things‽ Good question!

## Silliness

For one, I like silly things. I try not to take myself too seriously and adding a Rock-Paper-Scissors game to my portfolio definitely helps with that. (You should see some of the looks I get when I try to explain to people what I've been spending my free time on lately: priceless.)

It's too easy to lose sight of how fun coding can be on more "serious" projects. The terrors of bad legacy code, the pressures of looming deadlines, and the frustrations of being forced to make compromises all take a toll. It's sometimes hard to keep in mind just how fun all of this **should** be.

I have found my silly little side project to be a wonderful antidote for that. I've given myself permission to indulge my perfectionist tendencies whenever I feel like it. Looking at its [SonarQube analysis](https://justdavis.com/sonar/dashboard/index/com.justdavis.karl.rpstourney:rps-tourney-parent) provides several examples of that: 99.4% [API documentation rate](https://justdavis.com/sonar/drilldown/measures/44?highlight=public_documented_api_density&metric=public_undocumented_api) and over a third of the entire project is [comments](https://justdavis.com/sonar/drilldown/measures/44?metric=comment_lines_density). At the same time, I've also given myself permission to slack a bit when I wanted to. For example, [the overall test coverage](https://justdavis.com/sonar/drilldown/measures/44?metric=overall_coverage) is only 64.5% and I still haven't gotten around to making the integration tests run against a real browser. They just run against the mock [HtmlUnit](http://htmlunit.sourceforge.net/) browser for now. Who cares? It's only a Rock-Paper-Scissors game!

Working on something low-key like this game turns out to be a great way to de-stress after a long day. It's low-friction and easy to tinker with. I mean, there have been a few brain-meltingly-frustrating bugs that I've had to run down, but those are really just the exception that prove the rule here. And regardless, coding is just good therapy for me.

## Keeping My Hand In

Back when I started this project, I had found myself spending more time at work on management and sales tasks than on coding. This made me sad. Even now, after having switched teams to get back to full-time technical work, there are days where it feels like I wrote more lines of emails and meeting notes than code. A side project is the obvious solution to my problems, then and now.

Unfortunately though, my current employer has a rather regressive IP assignment agreement. Most of the actually interesting side project ideas I've come up with over the years have run afoul of it, and any work on those ideas could have ended up getting forcibly "donated" to my employer well after the fact. But after spending a lot of time frustrated by this, I eventually embraced it: if I couldn't work on anything lucrative or important, I'd work on something completely absurd instead.

That was the real genesis for this whole thing. I recall having the idea in the shower one day, the morning after a frustrating "didn't-get-to-code-again" day at work. A few minutes later, [RPS Tourney](https://github.com/karlmdavis/rps-tourney) was started! (Yet again demonstrating that all of my best ideas arrive in the shower.)

## Happy Little Trees

> "This is your world, you're the creator; find freedom on this canvas." — Bob Ross

A blank canvas is a magical and wonderful thing. The borders of a canvas provide structure for what happens inside of those lines. Same thing with *Whose Line Is It Anyway*, "the show where everything's made up and the points don't matter." The rules provide the framework that all of their creative insanity needs. With RPS Tourney, the actual game logic code is vanishingly tiny and has been done for ages and ages. The concept wasn't important in and of itself, but provided the excuse I needed to slowly explore the design, technology, UX, and other concepts that I actually wanted to delve into.

To that end, when I started the project I imposed a number of fairly arbitrary restrictions on myself:

1. I wrote up a list of libraries and technologies that I wanted to play with, and forced myself to use them—even if I ended up hating them.
2. I decided that the web application must be at least somewhat useable with JavaScript disabled.
3. I wanted to support anonymous users without forcing any sort of registration process, and still make their accounts as persistent and useable as possible.

The list of libraries and technologies that I came up with was a pretty... diverse cast of characters. My main selection criteria in choosing many of them wasn't whether or not I thought they were actually _good_ choices, but how widely-used they seemed to be and how unfamiliar I was with them. A lot of these technologies fell into the category of "I think it's probably awful, but it's quite popular so I wonder if I'm wrong." JSP and Spring are prime examples of this: they're used all over the place but I've always thought they looked like poor choices for my projects. This library experiment turned out to be fascinating—often painful, but fascinating. I'll write more about it in a future post; there's a lot to talk about. In the future, I also hope to create a few "what if I used _X_ instead of _Y_" branches to really explore the differences between the technologies used here and those that I would consider my "first choice" libraries. For example, I might go through and rebuild the web application frontend using [Wicket](https://wicket.apache.org/) instead of JSP and Spring MVC. Will I end up with less code? I think so, but I'd love to prove that one way or another.

My second restriction – choosing to support non-JavaScript browsers – was really just personal preference. I hate it when sites that _should_ be usable with [NoScript](https://noscript.net/) aren't. I figured a game was on the opposite end of that spectrum: it _shouldn't_ be useable without JavaScript, so trying to make it that way might be an interesting challenge. And it has been. I definitely wouldn't do it again without a good reason, but it was fun to work through the problems around it.

Surprisingly, my third restriction – enabling persistent anonymous user accounts – ended up being one of the most painful ones. This is largely a result of the general J2EE authentication model not really supporting the concept of a persistent user with no password, whose ID is just a cookie token. [Spring Security](http://projects.spring.io/spring-security/) proved particularly resistant to this. It feels like I spent more time and frustration on authentication in this application than I did on any other single feature.

Those self-imposed constraints were fairly arbitrary, but they ended up providing this project with what it needed most: a bit of a challenge.

## The Never Ending Story

Probably the most fascinating part of the project for me has been my attempt to release it as a [minumum viable product](https://en.wikipedia.org/wiki/Minimum_viable_product) (though "product" is a bit of a misstatement for a free game with no revenue model). Early experiments with my wife and a few friends very quickly proved to me that what I thought of as "rough, but useable" looked more like a hot, confused mess to them. Accordingly, I'm now working towards a [**fifth** pre-release](https://github.com/karlmdavis/rps-tourney/issues?utf8=%E2%9C%93&q=milestone%3A2.0.0-milestone.5+), when I'd expected to have shipped the final one sometime last year. This experience has really reshaped my thoughts on just how fundamentally important good user interface and experience design are.

I never expected this silly, throw-away side project of mine to capture my interest as much as it has. But it definitely has. I can see myself continuing to poke at it and use it as an excuse to play with new things for years more.


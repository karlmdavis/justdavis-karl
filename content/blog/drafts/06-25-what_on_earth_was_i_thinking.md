# What On Earth Was I Thinking?

What on earth was I thinking, deciding to spend my free time building a Rock-Paper-Scissors game, of all things?!

For well over a year now, I've been spending a good bit of my evening and weekend time on the most absurd side project I could invent: [RPS Tourney](https://github.com/karlmdavis/rps-tourney). Why would I spend my time on something so silly? Good question!

## Silliness

For one thing, I like silly. I try hard not to take myself too seriously and adding a Rock-Paper-Scissors game to my portfolio definitely helps with that. You should see some of the looks I get when I try to explain to people what I've been spending my free time on lately. Priceless.

When I say that I try hard not to take myself too seriously, I really mean that. It's hard sometimes. I take my job seriously, I take a lot of pride in what I do there, and that absolutely extends to my side projects. Really, it just extends to life in general. I'm one of those folks, who once they decide that the pile of papers on their desk is too dangerous to ignore (as in, it might fall over and crush me beneath its weight), will proceed not just to file the papers, but to go through each one, deal with whatever needs dealing with, and then scan and digitally file any of them I want to keep around. I'm the same way with email: once I start marching through it, I go for a while.

So my silly little side project has been a wonderful antidote for that. I've given myself permission with it to indulge all of my perfectionist tendencies when I feel like it. Looking at the [SonarQube analysis of it](https://justdavis.com/sonar/dashboard/index/com.justdavis.karl.rpstourney:rps-tourney-parent) provides several examples of that: 99.4% [API documentation rate](https://justdavis.com/sonar/drilldown/measures/44?highlight=public_documented_api_density&metric=public_undocumented_api), and over a third of the entire project is [comments](https://justdavis.com/sonar/drilldown/measures/44?metric=comment_lines_density). At the same time, I've also given myself permission to slack a bit when I feel like it. For example, [the overall test coverage](https://justdavis.com/sonar/drilldown/measures/44?metric=overall_coverage) is only 64.5%, and I still haven't gotten around to making the integration tests run against a real browser (they just run against [the mock HtmlUnit browser](http://htmlunit.sourceforge.net/), for now). Who cares? It's only a Rock-Paper-Scissors game!

Working on it is also a great way to de-stress after a long day. Tinkering with this project has generally been easy and low-friction. I mean, there have been a few brain-meltingly-frustrating bugs, but those are really just the exception that prove the rule here. Coding is therapy for me, regardless.

## Keeping My Hand In

Back when I started this project, I'd found myself spending more time at work on management and sales tasks than on coding. This made me sad. Also, I wanted to be one of those cool kids with awesome-sauce code up on GitHub. I was jealous of their great fame and general excellence. Clearly, I needed a side project.

Unfortunately though, my current employer has a rather regressive IP assignment agreement. Most of the actually interesting side project ideas I've come up with over the years have run afoul of it, and any work on those ideas could have ended up getting "donated" well after the fact. After spending a lot of time frustrated by this, I eventually embraced it: if I couldn't work on anything lucrative or important, I'd work on something completely absurd instead.

That was the real genesis for this whole thing. I recall having the idea in the shower one day, the morning after a frustrating "didn't-get-to-code-again" day at work. A few minutes later, [RPS Tourney](https://github.com/karlmdavis/rps-tourney) was born! This yet again proves that all of my best ideas happen during a shower.

That was a while ago and since then I've moved into different roles at work where I was able to code regularly. I've also gone through other coding "dry spells." I've been able to keep poking at this silly little side project that whole time, though, and it's really helped keep me sane.

## Happy Little Trees

It's turned out to be a wonderfully blank canvas. It's very similar in that way to *Whose Line Is It Anyway*, "the show where everything's made up and the points don't matter." The actual "game" portion of the project is vanishingly small, and has been done for ages and ages. Instead, it's provided just enough structure for me to slowly explore the design, technology, UX, etc. concepts _around_ the actual domain logic.

One of the things I really wanted to do with the project was to investigate various libraries, technologies, etc. that I hadn't yet had a good excuse to play with at my "day job." A lot of these technologies fell into the category of "I think it's probably awful, but it's quite popular so I wonder if I'm wrong." JSP and Spring are prime examples of this. That experiment turned out to be fascinating—incredibly painful, but fascinating. I'll probably write more about it in a future post; there's a lot to talk about. In the future, I also hope to create a few "what if I used Y instead of X" branches to really explore the differences between the technologies used here, and those that I would consider my "first choice" libraries. For example, I might go through and rebuild the web application frontend using [Wicket](https://wicket.apache.org/) instead of JSP and Spring MVC. Will I end up with less code? I think so, but I'd love to prove that one way or the other.

Probably the most fascinating part of the project for me has been my attempt to release it as a [minumum viable product](https://en.wikipedia.org/wiki/Minimum_viable_product) (though "product" is a bit of a misstatement for a free game with no revenue model). Early experiments with my wife and a few select friends very quickly proved to me that my idea of "rough, but useable" looked more like a hot, confused mess to them. Accordingly, I'm now working towards a ["milestone **4**" release](https://github.com/karlmdavis/rps-tourney/issues?utf8=%E2%9C%93&q=milestone%3A2.0.0-milestone.4+), when I'd expected to have shipped the final one sometime last year. This experience has really reshaped my thoughts on the importance of good user interface and experience design.

I really never expected this silly, throw-away side project of mine to capture my interest as much as it has. Even more surprisingly, I can see myself continuing to poke at it and use it as an excuse to play with new things for years more.


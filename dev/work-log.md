Work Log
========
*Tracking Work on my personal site.*


## Introduction

This log just tracks my work on the site. It's basically intended as an "electronic bookmark": helping me keep my place, so I don't forget what I was up to. I tend to work on the site intermittently (and often infrequently), so that's been a problem. But no more!

This file should never be committed along with other files; it should always be updated by itself. This will prevent any weird merge problems.


## Daily Log

### 2015-06-25, Thursday

* Renamed the GitHub repo from "doh-docs" to "justdavis-karl".
* Started this work log.
* 1.9h (7:32-8:32,20:49-21:44): [Issue #1: Write a blog post explaining RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/1)
    * Wrote and committed the first draft.
    * Worked a bit on a second, expanded draft.

### 2015-07-07, Tuesday

* _I've worked on this a few times since the last work log entry, but forgot to keep this file updated._
* 0.95h (08:32-09:28): [Issue #1: Write a blog post explaining RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/1)
    * Went through another quick edit, myself.
    * Need to add a screenshot. Maybe?
    * Definitely need to rework my site's template to be more mobile friendly? Bootstrapify it?
    * Sent it out to Mark, Steve, and Dann for review. Will probably also ask someone from work to review it, too.

### 2015-07-08, Wednesday

* 0.3h (09:01-09:18): [Issue #1: Write a blog post explaining RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/1)
* 0.25h (09:19-09:33): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)

### 2015-07-09, Thursday

* 0.5h (09:23-09:53): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Started drafting a pivot, wherein I frame the conversation around how badly estimates are handled everywhere.
* 0.1h (18:24-18:31): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)

### 2015-07-11, Saturday

* 0.2h (22:34-22:45): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)

### 2015-07-12, Sunday

* 2.35h (09:54-10:03,11:24-13:37): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Got a draft mostly completed, I think.

### 2015-07-13, Monday

* 0.35h (09:06-09:26): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Started going through the RPS issues, looking for estimates and recording them in the work log spreadsheet.
* 0.6h (20:09-20:46): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Finished the RPS estimate collation. Only have nine useable estimates, unfortunately.
* 0.75h (20:47-21:32): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Spent some time trying to find references on estimation accuracy.
        * This Wikipedia article is **excellent**: [Software development effort estimation](https://en.wikipedia.org/wiki/Software_development_effort_estimation)
        * I read through the abstract and conclusion of this excellent paper (which was referenced from Wikipedia): [Forecasting of Software Development Work Effort: Evidence on Expert Judgment and Formal Models](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.387.5379&rep=rep1&type=pdf)
            * It references an earlier 2004 paper by the same author that it sounds like I should track down and read as well.
    * Some later thoughts:
        * It would be better to introduce 3-point from a "first principles" perspective, i.e. tracking accuracy of your worst, best, and likely case estimates.
        * Managers also need to acknowledge and cope with industry-wide estimation inaccuracies.

### 2015-07-15, Wednesday

* 0.45h (08:54-09:20): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Read pages 1 through 8 of [A review of studies on expert estimation of software development effort](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.387.5976&rep=rep1&type=pdf). Mostly discusses how to make estimates better. Haven't yet seen any data here on how accurate they are.

### 2015-07-17, Friday

* 0.75h (07:21-07:32,07:52-08:27): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Read to page 19 of [A review of studies on expert estimation of software development effort](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.387.5976&rep=rep1&type=pdf)
        * Good quote on page 10: "The results from many human judgment studies indicate that people get over-optimistic when predicting own performance, i.e., they have problems separating "wish" and "realism"."
        * Good quote on page 10: See the fake quote of the software estimation game near the end of the page.
        * Good quote on page 11-12: "Jørgensen and Sjøberg (2002a) report that the information about the software development cost expected by the customer had a strong impact on the estimate even when the estimators were told that the customer knew nothing about the realistic costs and that the information should be regarded as irrelevant for the estimation task."
        * Good quote on page 12: "Consequently, it is may not be sufficient to warn against irrelevant information or instruct people to consider information as unreliable. The only safe approach seems to avoid irrelevant and unreliable information."
        * Good quote on page 12: "... software project cost overruns were associated with lack of documented data from previous tasks, i.e., high reliance on "personal memory"."
        * Good description near the start of page 15 of an estimation checklist.
        * Page 16: "it is reported that a group discussion-based combination of individual software development effort estimates was more accurate than the average of the individual estimates, because the group discussion led to new knowledge about the interaction between people in different roles."
        * Page 16: "Connolly and Dean (1997) report that the hit rates of students’ effort predictions intervals were, on average, 60% when a 90% confidence level was required."
        * Page 17: describes a three-point estimation strategy where the min and max estimates are fixed multiples of the "most likely" estimate (50% and 200%). Apparently, we all suck at determining realistic mins & maxes.
        * Page 17: "... experience has been shown to be unrelated to the empirical accuracy of expert judgments."

### 2015-07-19, Sunday

* 0.55h (17:03-17:35): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Finished reading [A review of studies on expert estimation of software development effort](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.387.5976&rep=rep1&type=pdf).
    * Need to read the following paper: [An empirical study of maintenance and development estimation accuracy, Kitchenham, 2002](http://www.sciencedirect.com/science/article/pii/S0164121202000213).
    * Read to page 4 of [Better sure than safe? Over-confidence in judgement based software development effort prediction intervals, Jørgensen, 2004](http://www.researchgate.net/publication/222433989_Better_sure_than_safe_Over-confidence_in_judgement_based_software_development_effort_prediction_intervals).
    * Need to go read his list of paper titles, to see if there are any major advances in this field of study in the last decade.

### 2015-07-22, Wednesday

* 0.4h (15:49-16:14): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Skimmed/read through the rest of [Better sure than safe? Over-confidence in judgement based software development effort prediction intervals, Jørgensen, 2004](http://www.researchgate.net/publication/222433989_Better_sure_than_safe_Over-confidence_in_judgement_based_software_development_effort_prediction_intervals).
        * Conclusion: people suck at estimation. Full stop.
    * Read through all of [What We Do and Don't Know About Software Development Effort Estimation, Jørgensen, 2014](https://www.simula.no/file/simulasimula2440pdf/download?token=6-zem-VY).
        * An excellent summary of where things stand.
        * Spoiler: we still suck at estimation.
* 0.55h (16:44-17:17): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Started editing the draft again. Got up through the "Where Do Estimates Come From?" section.
* 1.15h (20:43-21:12,22:01-22:42): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Almost finished this draft. Need to drop a couple of quotes in, but think it's about done.

### 2015-07-23, Thursday

* 1.85h (05:58-07:50): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Completed the draft.
    * Put together the estimation template/sample.

### 2015-07-26, Sunday

* 1.55h (21:15-22:49): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Did another quick edit myself.
    * Had Erica review it and applied her feedback.
    * Renamed the file, split the earlier contents into a new one, and renamed the GitHub issue.

### 2015-07-27, Monday

* 1.25h (08:16-09:32): [Issue #1: Write a blog post explaining RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/1)
    * Applied Steve's feedback.
    * Published it.

### 2015-08-01, Saturday

* 0.7h (23:21-00:02): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Went through and applied Mark's feedback.
    * Went through and applied Dave's feedback.
    * Responded to Brett's feedback.

### 2015-08-02, Sunday

* 1.6h (09:46-11:23): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Went through and applied Paul's feedback.
    * Need to deal with that TODO.

### 2015-08-06, Thursday

* 1.0h (20:45-21:45): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * (Also went through and committed misc content updates I had laying around.)
    * Because nanoc-3 doesn't support file-with-same-names-but-different-extensions in the same directory, it is not compatible with Bootstrap.
    * If I want to use nanoc-4 (beta), I'll need a newer version of Ruby than Ubuntu 14.04 has.
        * I think I probably do want to spend the time it'll take to make the switch, but this could easily turn into a boondoggle.
        * What if v4 doesn't yet support all of the same filters, or the blog extensions? What if I lose my old wiki content?
    * Also took a look at other static site generators. Jekyll definitely seems to be winning, and easily has the best docs.

### 2015-08-09, Sunday

* 0.5h (14:59-15:28): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Spent some time reading around. Think I will bite the bullet and try to move the blog to Jekyll.
        * Jekyll 3.0 will be released soon, but it appears to be mostly backwards compatible.
        * I don't really want to lose my old wiki, but I also don't want to have to find a plugin to support it. Might just be easier to manually convert it to Markdown.
    * Need to do this in a branch.

### 2015-08-16, Sunday

* 0.1h (14:16-14:21): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Created a new branch for the switch to Jekyll, and got it pushed to GitHub.
* 1.15h (14:21-14:34,18:38-19:21,19:40-19:53): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Added in the estimation formulas (via MathML), per the TODO. Committed.
    * Published the post. Pushed and deployed.

### 2015-08-18, Tuesday

* 0.6h (10:25-10:50): [Issue #4: Write a blog post about library choice](https://github.com/karlmdavis/justdavis-karl/issues/4)
    * Started drafting it on my phone.

### 2015-08-19, Wednesday

* 0.3h (14:37-14:54): [Issue #2: Write a blog post discussing the work log data from RPS Tourney](https://github.com/karlmdavis/justdavis-karl/issues/2)
    * Fixed the missing CSS styling, e.g. for `blockquote` that I happened to notice. Whoops.


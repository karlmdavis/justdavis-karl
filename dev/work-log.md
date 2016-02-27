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

### 2015-08-17, Monday

* 0.5h (22:34-22:53): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Started installing `rvm`, which will be needed since Jekyll doesn't support Trusty's version of Ruby.

### 2015-08-21, Friday

* 0.5h (23:32-23:53): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got RVM installed. Need to figure out gemsets next.

### 2015-08-29, Saturday

* 0.75h (23:30-00:16): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got a gemset created and installed Jekyll into it.
    * Played around a bit with a new Jekyll site. Need to figure out the simplest way to integrate Bootstrap.

### 2015-08-30, Sunday

* 0.4h (14:53-15:18): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * I might be able to use the [jekyll-assets](http://ixti.net/jekyll-assets/) plugin to integrate in Bootstrap.
    * If not, I should just give up and use the pre-compiled version.

### 2015-11-08, Sunday

* 1.6h (11:43-13:19): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got things running again.
    * Got the `jekyll-assets` plugin working, and pulling in Bootstrap 3 via `bootstrap-sass`.
    * Need to start pulling apart the template and putting it back together how I want it.

### 2015-11-09, Monday

* 0.15h (21:44-21:54): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Looked through personal sites for design inspiration.

### 2015-11-12, Thursday

* 0.5h (08:11-8:41): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got the Bootstrap minimal sample in place.
    * Got Bootstrap's JS working.

### 2015-11-13, Friday

* 0.1h (23:58-00:03): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Decided to use the Bootstrap blog template as a starting point.

### 2015-11-14, Saturday

* 0.2h (19:41-19:52): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Started pulling the template together. Didn't get too far: got bored.

### 2015-11-15, Sunday

* 0.45h (17:21-17:47): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Working on recreating Bootstrap's example "blog theme".

### 2015-11-16, Monday

* 0.15h (09:59-10:09): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got the nav and footer looking about right.
* 0.25h (17:14-17:28): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Worked on the home page a bit. Added a jumbotron and 3-column feature.
* 0.55h (20:35-21:08): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Spent some time trying to decide how hierarchical docs could work. No luck so far.

### 2015-11-17, Tuesday

* 0.25h (10:20-10:35): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Came across Jekyll's "collections" feature, which is *exactly* what I needed. Yay!: <http://jekyllrb.com/docs/collections/>

### 2015-11-19, Thursday

* 0.2h (21:54-22:05): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got my devenv running again.
    * Got the `it_docs` collection itself working, but can't get the index for it right.

### 2015-11-21, Saturday

* 1.25h (17:02-18:16): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Figured out how to get the IT collection's index working.
        * Key lesson #1: Don't have a root page with the same name as a collection.
        * Key lesson #2: Any changes to the config require restarting `jekyll serve`.
    * Also learned that the site's `baseurl` has to be prepended to every link. Dumb, but okay.

### 2015-11-22, Sunday

* 1.25h (14:44-15:59): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Hacked out a rough understanding of how to link to collection items in Liquid. Very painful learning experience.

### 2015-11-23, Monday

* 1.45h (19:19-20:02,21:35-22:20): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got a first Collections URL plugin written. Doesn't yet handle `baseurl`.

### 2015-11-24, Tuesday

* 0.2h (07:58-08:11): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * If I want to parse tag options, to enable `baseurl` handling, I'm going to have to do it via regex. Yuck.

### 2015-11-25, Wednesday

* 0.15h (19:39-19:49): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * The second parameter in tag constructors seems to be all of the parameters, combined as a single string. Yuck!

### 2015-11-28, Saturday

* 0.1h (16:30-16:36): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got my devenv back up (after a restart). Didn't feel like playing with regexes right now, though.

### 2015-11-30, Monday

* 0.45h (19:56-20:22): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Worked on creating a regex for a while. Still needs to handle item IDs with whitespace.

### 2015-12-01, Tuesday

* 0.7h (21:47-22:30): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Banged on the regex for a while.
    * Think I have it handling quoted IDs.
    * Will need a second-stage regex for breaking up the key-value pairs, using `scan` or somesuch. Can't be done with a single regex.

### 2015-12-02, Wednesday

* 0.55h (21:46-22:20): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got the properties parsing working, along with the `baseurl` support that required it.

### 2015-12-03, Thursday

* 0.3h (20:37-20:56): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * This seems like it's about where I need to branch in Git and start actually tracking my changes...
        * I think I've proven now that all of the tricky stuff is possible.
        * Just have to slog through all of it, I guess.
        * Oh, I'm a goof: I already had branched. Silly me.
    * Got things a bit cleaned up and committed to that branch. Feels good.

### 2015-12-05, Saturday

* 0.6h (23:03-23:39): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Added in the other `collection_doc_*` tag types. Yay!

### 2015-12-06, Sunday

* 0.95h (20:22-21:19): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Banged on the front page a good bit. Starting to look decent.

### 2015-12-07, Monday

* 0.6h (20:41-21:17): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Worked on styling the front page a bit more. Pretty happy with it now, I think.
    * Started building the `/projects` page.

### 2015-12-09, Wednesday

* 0.65h (22:17-22:21,23:59-00:34): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Finished the `/project` page's layout.
    * Bootstrap doesn't have good support for equal height columns, so each project needs to fill a whole row.

### 2015-12-11, Friday

* 0.15h (18:05-18:14): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Finished the copy on the `/projects` page.

### 2015-12-12, Saturday

* 0.65h (21:51-22:29): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Committed the work done so far.
    * Fixed up the nav.
    * Worked on the `/blog` page.
    * Something's up with the URLs for `_posts` content. Whyfor?

### 2015-12-13, Sunday

* 0.75h (12:39-12:48,13:34-14:08): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Started trying to fix the nav's `active` setting. Looks like Jekyll doesn't really allow for custom functions, as such.
    * Need to reimplement it as a custom tag.

### 2016-01-01, Friday

* 0.4h (16:38-17:03): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Fixed the navbar active/inactive badges. Committed.

### 2016-01-03, Sunday

* 0.65h (21:40-22:20): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Created the `/blog` frontpage/list. Reasonably happy with it; pretty much the same as the projects page.

### 2016-02-23, Tuesday

* 0.55h (21:15-21:48): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Got things fired up again.
    * Documented how to run the site locally, since it'd fallen out of my Bash history.
    * Fixed a link in the blog frontpage.
    * Fixed the gutter at the bottom of pages.
    * Tweaked the blog post layout some. Done? Not sure.

### 2016-02-24, Wednesday

* 0.25h (07:05-07:11,08:00-08:11): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * First pass at formatting the IT Docs frontpage.
    * Hadn't I added some metadata to those pages that'd allow me to group them by category?
* 0.8h (21:49-22:37): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Had to leave things broken, due to lack of internet (on a plane):
        * How to pass IDs using a variable in `collection_doc_link_long`?
        * How to write an `if` block that verifies a field is missing?

### 2016-02-26, Friday

* 0.7h (07:00-07:41): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Enhanced collection links to support variable item IDs.

### 2016-02-26, Friday

* 0.5h (12:45-13:15): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Fixed a bug that had completely broken collection doc links. How had I missed that?! Been there forever, I think.
    * Made the last tweaks (for now) to the layout and all that.
    * Time for content!
* 1.15h (15:22-16:31): [Issue #3: Update my website template to look better (and be mobile-friendly)](https://github.com/karlmdavis/justdavis-karl/issues/3)
    * Migrated all of my blog posts from nanoc to Jekyll!


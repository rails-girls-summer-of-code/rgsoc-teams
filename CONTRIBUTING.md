# Contributing to the RGSoC Teams App

First of all, thank you for your contribution to the RGSoC Teams App. Or the consideration thereof. :smile: The Teams App is a collaborative effort of [many contributors](https://github.com/rails-girls-summer-of-code/rgsoc-teams/graphs/contributors).

Please note our [Code of Conduct](https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/CODE_OF_CONDUCT.md).

There are different ways to get involved:

0. [Find work that needs to be done](#find-work-that-needs-to-be-done)
1. [Reporting an error](#reporting-an-error)
2. [Suggesting a new feature](#suggesting-a-new-feature)
3. [Resolving an existing issue](#resolving-an-existing-issue)

## Find work that needs to be done

How things are organized:

### Labels

We use labels to track, manage and organize issues and pull requests.

| Label Name         | Issues                  | Description |
| ------------------ |:-----------------------:| ------------|
| `beginner-friendly`| [🔍][beginner]      | Less complex issues, suitable for your first steps in open source. |
| `bug`              | [🔍][bug]           | Confirmed misbehavior of the application code. |
| `duplicate`        | [🔍][duplicate]     | Issues which have already been reported. |
| `in progress`      | [🔍][in progress]   | Work in progress, things which are already taken care of. |
| `invalid`          | [🔍][invalid]       | Issues which aren't *"real"* issues (e.g. user errors). |
| `#pairwithme`      | [🔍][#pairwithme]   | Looking for someone to pair on this. |
| `question`         | [🔍][question]      | Feature and code related questions which are no bug reports or feature requests. |
| `rgsoc-<year>`     | [🔍][rgsoc-<year>]  | Issues intended for students working on the Teams App during RGSoC in a given `<year>`. |
| `styling`          | [🔍][styling]       | CSS and UI related things. |
| `wontfix`          | [🔍][wontfix]       | The team has decided to not fix these things for now, e.g. because the whole feature will be replaced soon. |
| `would be nice`    | [🔍][would be nice] | Features and enhancement which are *"nice to have"* but not super necessary. |

[beginner]:      https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/beginner-friendly
[bug]:           https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/bug
[duplicate]:     https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/duplicate
[enhancement]:   https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/enhancement
[in progress]:   https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/in%20progress
[invalid]:       https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/invalid
[#pairwithme]:   https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/%23pairwithme
[question]:      https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/question
[rgsoc-<year>]:  https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/rgsoc-2016
[styling]:       https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/styling
[wontfix]:       https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/wontfix
[would be nice]: https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/would%20be%20nice

## Reporting an error

Reporting a bug is very important and we appreciate the time you take to inform us about the Teams App's mischief. Before you do, we kindly ask you to check if [it has already been reported](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues?q=is%3Aopen+is%3Aissue+label%3Abug).

If you do [file a new  bug report](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues/new), provide as many details as possible: how can the error be reproduced? What was the expected and what the actual behaviour? Can you provide an error message or a screenshot that illustrates the problem?


## Suggesting a new feature

We are very open to feature requests and ideas to improve the Teams App. If you are a RGSoC student or supervisor who uses the Teams App on a daily basis over the course of the summer, your feedback on how the user experience can be improved is very valuable.

As with filing a bug report, please check if the feature has [already been suggested](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues). If not, [share your ideas](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues/new)!


## Resolving an existing issue

If you want to get involved with the RGSoC Teams App, the [list of open issues](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues) is a good starting point.

### Finding an issue

We have issues labelled as [`beginner-friendly`](https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues?q=is%3Aissue+is%3Aopen+label%3Abeginner-friendly) suitable for your first steps in open source. See [`#pairwithme`](https://github.com/rails-girls-summer-of-code/rgsoc-teams/labels/%23pairwithme) for more involving issues and the standing invitation to work on a problem together (check [this great list of resources](http://www.pairprogramwith.me/) about (remote) pair programming).

Before you start working, make sure no one else is already working on it: check if the issue has been assigned to someone already and/or comment on the issue. Adding comments is also the best way to ask questions about the issue at hand or if the issue is still valid.

If you've confirmed that no one is working on the issue and would like to give it a go, feel free to leave a comment saying so! You could write something like the following:

    I think I know how to fix this one! Will give it a try :thumbsup:

### Creating a Pull Request

Clone/fork the repo and install the Teams App locally on your computer. Our [README](https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/README.md) provides setup instructions and hints).

Before you start working, make sure tests pass locally: run `bundle exec rake spec` from the terminal in your local Teams App directory. There should be plenty of green dots (and some in yellow).

### Create a Topic Branch

All commits should go into a branch, not to `master` directly. Create a local branch:

```
git checkout -b my-feature-branch
```

If you've cloned the app a while ago, you want to make sure that your cloned `master` is in sync with the upstream. Github provives a help page on [how to keeping your fork in sync with `upstream/master`](https://help.github.com/articles/syncing-a-fork/).

### Write Code

We aim to follow the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) and have [RuboCop](https://github.com/bbatsov/rubocop) set up to make sure we stay consistent with some basic rules (see our [rubocop.yml](https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/.rubocop.yml) file for details).  
But don't be afraid, those are friendly cops who are here to help you with formatting your code 👮

We prefer JavaScript (`*.js`) over CoffeeScript (`*.coffee`). jQuery is perfectly fine, but if you can, use [Vanilla JS instead of jQuery](https://gist.github.com/liamcurry/2597326). Indentation for JavaScript files: four whitespaces.

If you enjoy polishing up other people's code: be aware that **purely** *code-cosmetic* changes are likely to not be accepted. We aim to be welcoming to beginners. So while e.g. pointing out accidental N+1 queries is a useful contribution, just rewriting things to look more conventional can be discouraging for newcomers.

We would ask you to write tests for your code: A well defined test suite is as much part of the app as the tested code itself. It helps to ascertain the well-being of any software product - the Teams App being no exception here. But this should not be a blocker. See the existing tests to find out where yours would fit in and in case it's hard to get started, ask us, we'll help.

Make atomic commits with a descriptive commit message.

### Make a Pull Request

Github [provides documentation](https://help.github.com/articles/creating-a-pull-request/) on how to create a PR. A new PR (and any subsequent updates to it) will trigger running the test suite and automatic code analyzers on Travis CI.

If your contribution alters the way the Teams App looks (e.g. CSS changes), we kindly ask you to provide a few screenshots (before/after) that illustrate the change. It's much easier and quicker to review as we won't have to checkout the PR locally. You can drag'n'drop image files directly into the PR description or its comments section.

### Be Patient

Please give us a few days to get back to you. Thank you so much!

### Ping Method™

You and a person reviewing your code agreed to update your pull request with certain changes? Please `@-mention` the person in the comments once you are done and the code is ready to be reviewed again.

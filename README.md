# Tracker CLI

A mostly-for-fun Command Line Interface (CLI) for Pivotal Tracker

# Installation

## Configure

An API Token and Project ID are required in the configuration file.

### 1) Find your API Token

Your API Token is located at https://www.pivotaltracker.com/profile.

### 2) Find your Project ID

Your Project ID is located in the project's url. If your project url is https://www.pivotaltracker.com/n/projects/999999, this project's id is 999999.

### 3) Create a config file

Open ~/.tracker.config in your favorite text editor and enter the following yaml:

```
api_token: {{API_TOKEN}}
project: {{PROJECT_ID}}
```

## Add to your Gemfile

```
gem 'tracker-cli', github: 'benastan/tracker-cli'
```

## Take it for a test drive

```
tracker --list stories
=> 00001  "My First Story"
```

# Usage

## List

```
tracker --list stories

00001 "Story 1"
00002 "Story 2"

tracker --list stories --format json # JSON format
tracker --list projects
tracker --list projects --format json # JSON format
```

## Fetch

```
tracker --fetch [OBJECT_TYPE]
```

`OBJECT_TYPE` can be story.
 
### Story

A story can be fetched interactively: 

```
tracker --fetch story -i
 
(1) 00001 "Story #1"
(2) 00002 "Story #2"
(3) 00002 "Story #3"
 
Which Story? 1
```

Or with an id: 

```
tracker --fetch story --id 00001
```

Make a commit for a started story of your choice.

```
tracker --fetch story -i --parameter with_state,started --commit
(1) 133544285 "Test Story"

Which Story? 1

[master 2886e30] [#133544285] Test Story
 7 files changed, 94 insertions(+), 23 deletions(-)
```

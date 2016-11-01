# Tracker CLI

A mostly for-fun cli for Pivotal Tracker.

# Installation

## Configure

Both an api token and a project id are required in the configuration file.

### 1) Find your API Token

You can find your api token at https://www.pivotaltracker.com/profile.

### 2) Find your Project ID

You can find your project id by navigating to the project and grabbing the last part of the url's path.

For example, if your project url is https://www.pivotaltracker.com/n/projects/999999, this project's id is 999999.

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
tracker --list [OBJECT_TYPE]
```

`OBJECT_TYPE` can be stories.

Available formats: json

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

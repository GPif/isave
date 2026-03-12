# WeSave Backend Challenge - iSave

Version en Français [ici](README.fr.md).

## Requirements

- `ruby` version 3.3.1
- `sqlite3`

## Introduction

Welcome to the WeSave Tech Challenge!

Your task is to build **the backend API** of a web app, iSave, that helps clients manage their investments based on their financial goals. The core of this application is based on portfolio management and financial indicators.

## Submission Instructions

- Clone this repository (do not fork it).
- Implement the features described in [LEVELS.md](LEVELS.md).
- Solve the levels in ascending order.
- Write tests to cover the implemented functionality.
- Ensure your code is well-documented. You are expected to provide instructions on how to run the application and use the API.
- You can make as many commits as you’d like for each level. Every commit should follow the [Conventional Commit Standard](https://www.conventionalcommits.org/en/v1.0.0/), as follows:

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Example:

```txt
chore(init): this is the first commit

Add the basic requirements to the application

Level-1
```

## Evaluation Criteria

Your submission will be evaluated based on:

- **Functionality**: How well does the backend meet the requirements?
- **Code Quality**: Is the code well-organized, commented, and maintainable?
- **Testing**: Are there adequate tests to ensure the functionality is correct and reliable?

## Setup Instructions

1. Clone the repository (do not fork it): `git clone https://gitlab.com/anatec/wesave/isave-backend-test-2024.git`
2. Install the required Ruby version (~>3.3.1)
3. Install dependencies: `bundle install`
4. Set up the database (if needed): `rake db:create db:migrate`

## Submitting Your Work

When you have completed your work, please submit your results to your contact person at WeSave. You can either:
- Share a link to your project on Github, Gitlab, or Bitbucket to one of the following handles:
  - Github: `@nezih-anatec`
  - Gitlab: `@nezih1`
- OR zip your project directory (make sure to include the `.git` folder) and send it via email.

## The Challenge

In the [LEVELS.md](LEVELS.md) file, you will find 5 levels, each one progressively more difficult. Your task is to complete as many levels as possible within the time limit, showcasing your skills.

## Time Estimates

Each level is designed to take between half an hour to 2 hours, depending on the complexity.

## Tips

- You are free to look ahead at the higher levels, but try to focus on completing the current level with the simplest solution possible.
- As the levels become more complex, you will likely need to reuse and adapt previous code. A good approach is to use Object-Oriented Programming (OOP), adding new layers of abstraction when necessary, and writing tests to ensure you don't break any existing functionality.
- Feel free to write "shameless code" at first and refactor it in later levels.
- For the higher levels, we are interested in clean, extensible, and robust code. Pay attention to edge cases and use exceptions when needed.

**Additional notes:**
- Authentication is **not** required for this application.
- You are allowed to use any publicly available gems.
- All amounts should be stored as decimal.
- All asset prices will be defined in the same currency.

**Good luck!**

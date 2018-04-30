# Troubleshooting Guide

A collection of potential issues (and their solutions) people may face when working on the Teams App.

Glossary:  
🐧 = hint for Linux users  
🍏 = hint for macOS users

## Setup

Potential problems when setting up the local development environment.

### Chromedriver

#### Scenario

when running the tests in `spec/features/` you run into an error like this:

    Selenium::WebDriver::Error::WebDriverError:
        Unable to find chromedriver

#### Get Help

- make sure you have [chromedriver][chromedriver] and the [Chrome browser][chrome] installed on your system
- check the [Selenium Troubleshooting guide][selenium]
- 🐧 make sure the `chromedriver` executable is in your `PATH`:  

      export PATH=$PATH:/usr/lib/chromium-browser/

    *you may want to add this line to your `bashrc` / `zshrc` to make things permanent*
- check if you previously installed `chromedriver` via gem for a different Ruby version:
      which chromedriver

    this may e.g. return:

      /Users/xxx/.rbenv/shims/chromedriver

    at best remove all occurrences of:

      /.rbenv/versions/x.x.x/bin/chromedriver

    and install it manually via apt or homebrew.

[chromedriver]: https://sites.google.com/a/chromium.org/chromedriver/
[chrome]: https://sites.google.com/a/chromium.org/chromedriver/
[selenium]: https://sites.google.com/a/chromium.org/chromedriver/

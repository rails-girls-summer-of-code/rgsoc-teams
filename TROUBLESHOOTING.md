# Troubleshooting Guide

A collection of potential issues (and their solutions) people may face when working on the Teams App.

Glossary:  
🐧 = hint for Linux users  
🍏 = hint for macOS users

## Setup

Potential problems when setting up the local development environment.

### Chromedriver

**Scenario:**  
when running the tests in `spec/features/` you run into an error like this:

    Selenium::WebDriver::Error::WebDriverError:
        Unable to find chromedriver

**Where to get help:**  
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

### Mailtrap

#### Scenario

Running the project with `foreman` and Mailtrap does not work?

#### Get Help

Maybe `.env` does not set your `InboxUsername` and `InboxPassword` as environent variables? Try setting them manually.

Stop your running foreman process, then in your terminal:
```bash
export MAILTRAP_USER='<your-user-code>'
export MAILTRAP_PASSWORD='<your-pass-code'

# and restart the server "normally"
./bin/rails server
```

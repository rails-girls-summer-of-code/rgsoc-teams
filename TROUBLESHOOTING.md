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

# Misc. periodically occuring bugs (only locally)

#### NSPlaceholderDictionary initialize error 

You may run into this problem depending on what version of macOS you have (Catalina). This error usually throws after you have just set postgres up and are trying to run the RGSoC app locally. If this does occur, this can be solved by running the following in your console: 

    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES 
    
Then start the server locally again using: 

    rails s -p 3000 
    
Make sure there's not another instance of RGSoC running, if so you can bind to another port, or quit the current instance, in either case you may need to run the initial command again. 
    
#### OmniAuth logout 

On occasion if you logout locally, you'll get an error thrown at you when you try and log back in via OmniAuth. This is only occurring locally, and the error completely stops when you bind the port. This can be accomplished by pressing Control+C (to shut down your local instance) and then restarting the instance via: 

    rails s -b 0.0.0.0 -p 3000

This will fix the OmniAuth error locally, and run the teams app successfully. 

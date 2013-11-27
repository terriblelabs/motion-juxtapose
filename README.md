# Juxtapose

Screenshot-driven assertions for testing RubyMotion applications.

## Installation

Add this line to your application's Gemfile:

    gem 'juxtapose'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install juxtapose

## Usage

### MacBacon

Juxtapose provides a single new matcher: `it_should_look_like` takes a single argument, a descriptive string predicate of what the screen should look like.

Example:

    describe "home controller" do
      extend Juxtapose
    
      describe "home controller" do
        tests HomeViewController
    
        it "has a button that moves when tapped" do
          tap "Goodbye, world!"
          it_should_look_like "when_tapped"
        end
      end
    end

### Frank

Add the following config to your features/support/env.rb:

    require 'juxtapose'
    Juxtapose::FrankStrategy.setup

This lets you write a screenshot matcher along the lines of:

     Then /^the screen should match "([^\"]*)"$/ do |template|
       wait_for_nothing_to_be_animating
       screenshotter = Juxtapose::Screenshotter.new(self, template)
       expect(screenshotter.verify).to eq(true)
     end

### Juxtapose Server

Juxtapose comes with a small webapp that you can use to view your screenshot specs, see diffs between accepted and failing specs and accept any changed images that are expected changes. 

To start it, run `juxtapose` in the root of your project and browse to localhost:4567.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

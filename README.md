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

Juxtapose provides a single new matcher: `it_should_look_like`.

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

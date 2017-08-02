# Ruby Dev Box

This is a very simple [vagrant](https://www.vagrantup.com/) box for ruby/rails development.

Includes ruby, rails, rbenv, rvm, node, yarn, and postgres.

https://app.vagrantup.com/wazzasoft/boxes/ruby-dev

## Usage

Generate the Vagrantfile
```bash
$ vagrant init wazzasoft/ruby-dev
```

Or, create it yourself.

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "wazzasoft/ruby-dev"
end
```

Then simply vagrant up.
```bash
$ vagrant up
```

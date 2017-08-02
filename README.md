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

## Meta Development

The actual box is based on [bento/ubuntu-16.04](https://app.vagrantup.com/bento/boxes/ubuntu-16.04).

To turn bento's box into wazzasoft's, just clone this repository and do a `vagrant up`. This will start up the bento box and run `setup.sh` installing all of the necessities. After that, start up a new terminal session and you'll be all set.

After modifications, if you want to repackage the box, then follow these steps:

```bash
### Inside vagrant machine
# Make the box as small as possible
$ sudo apt-get clean
$ sudo dd if=/dev/zero of=/EMPTY bs=1M
$ sudo rm -f /EMPTY
# Clear bash history and exit
$ cat /dev/null > ~/.bash_history && history -c && exit

### Inside host machine
# Package the new box up:
$ vagrant package --output my-new-box.box
```

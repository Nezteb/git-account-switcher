# Git Account Switcher

The original script I wrote for this is `git-account-switcher.sh`. It is bad; it only works for two accounts and requires setting environment variables.

# TODO

- Figure out how to make executable named differently than the repo/package.
- Implement `help`, `add`, `remove`, `switch`.
- Figure out how to store usernames, key locations. Probably a config file.
- Figure out how to check current git account. Probably with SSH key parsing (like the script does).

# Future Documentation

So far this is only targeting Github accounts via SSH. Other providers and HTTPS will come later.

To build/install: `make`

Fun fact: any executable in your PATH named `git-<command>` is automatically retrieved by `git` so you can run it as a subcommand: `git <command>`.
- `git-myCommand` -> `git myCommand`
- `git-doMagic.sh` -> `git doMagic`
- And so on.


In this case, this repo is named `git-account-switcher`, but the command is `git-account`, so you would run it as: `git account`.

Basic usage: `git account help`

Subcommands:
- `git account init {name}`
  - Initialize the tool with the currently active git account and name it `{name}`.
  - Not required to run, but convenient.
- `git account list`
  - Returns a list of all accounts registered with the tool.
- `git account add {name}`
  - Add a new account and name it `{name}`.
- `git account remove {name}`
  - Remove the account with the name of `{name}`.
- `git account switch {name}`
  - Switch to the registered account with the name of `{name}`.

`init`, `add`, and `switch` will fail if the given name is already regisetered.

`remove` will fail if the given name is not already registered.
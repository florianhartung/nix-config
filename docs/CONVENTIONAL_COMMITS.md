# Conventional Commits (and extensions)

Personally, I like conventional commits. Considering they were mostly made for
software development and not for work on configuration files, I made the choice
to extend them for this repository.

The following commit types are used:

- feat: adds a completely new feature or changes an existing feature a lot
- refactor: non-functional changes
- chore: for updating lockfiles, running formatters, fixing lints
- add: adds a new package from some config
- remove: removes a package from some config

Also, I use scope to encode that work was done on a specific configuration. My
scopes consist of two parts delimited by a `:`. The first part must be `os` or
`home` and the second part must be the nixos or home configuration name. Some
example commit messages:

```
add(home:flo): firefox
feat(os:desktop): automatic garbage collection
```

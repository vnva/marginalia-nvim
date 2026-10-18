# Contributing

## Commits

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
<type>(<scope>): <summary>

<body>
```

- **type**: one of
  - `feat`: a new feature or highlight group;
  - `fix`: a fix for something broken;
  - `docs`: docs only;
  - `refactor`: a change in structure, with the same result;
  - `chore`: upkeep, such as a new `palette.lua` from marginalia-root.
- **scope**: optional. An area (`treesitter`, `lsp`, `diff`) or a plugin (`gitsigns`).
- **summary**: lowercase, in the imperative ("add", not "added"), no period at the end, up to 72 characters.
- **body**: optional. Explain why the change is made.

Example:

```
feat(gitsigns): colour the signs like a diff

Added lines are green and removed lines are red, as in the terminal.
```

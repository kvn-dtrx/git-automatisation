# git-hub-automatisation

**WARNING**: As indicated by the commit messages (most following the pattern wip: *), not everything is fully functional yet!

## Synopsis

This repository collects

- hooks for git,
- workflows for GitHub,
- further git-related scripts

which the author uses throughout his repositories.

## Repository Structure

- `.github`: GitHub-specific configuration files for workflows and templates.[^readme]
    - `workflow-templates`: Provides starter workflow templates that appear in the GitHub UI when initializing workflows in other repositories. These are intended for copy-and-customize use.
    - `workflows`: GitHub reusable workflows used for continuous integration, deployment, or other automated tasks.

- `scripts`: Scripts capturing the core functionality.
    - `ci`: Scripts used in continuous integration (e.g., GitHub Actions).
    - `pre-commit`: Scripts integrated with the pre-commit framework to run before committing code.
    - `tools`: Scripts related to git for (non-event based) local use, such as automation helpers or reporting tools.

- `.commitlintrc.js`: Configuration for [Commitlint](https://github.com/conventional-changelog/commitlint), which checks commit messages against a conventional format.

- `.pre-commit-config.yaml`: This file specifies [pre-commit](https://pre-commit.com) git hooks that should be applied to the repository itself.

- `.pre-commit-hooks.yaml`: This file provides pre-commit git hooks that other repositories can apply.

[^readme]: By the way, a README file located in `./.github` takes precedence over a README file in `.` when displayed on GitHub.

## GitHub Workflows

### Disabling Workflows

There is no built-in way to disable workflows. But GitHub only recognises configuration files as workflows if their filepaths match `./.github/workflows/*.y{,a}ml`.

### "Run Core Task" Subjob

Although it is a bit boilerplate, it is recommended to write:

``` yaml
- name: Run Core Task
  env:
    SCRIPT_URL: <script-url>
    <further env variables>
  run: |
    curl -fslL "${SCRIPT_URL}" -o tmp_script
    chmod +x tmp_script
    ./tmp_script
```

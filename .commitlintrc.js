// ---
// description: Configuration file for commitlint, which is used to lint commit messages.
// ---

// ---

module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      // Error level:
      // 0: off
      // 1: warn
      // 2: error
      2,
      // When to apply the rule
      'always',
      [
        // Changes that affect the build system or external dependencies
        'build',
        // Routine tasks or maintenance
        'chore',
        // Changes to CI configuration files and scripts
        'ci',
        // Configuration-related changes
        'config',
        // Marking code as deprecated
        'deprecate',
        // Documentation updates
        'docs',
        // New features
        'feat',
        // Bug fixes
        'fix',
        // Enhancements to existing functionality
        'improvement',
        // Performance improvements
        'perf',
        // Code refactoring without changing functionality
        'refactor',
        // Reverting a previous commit
        'revert',
        // Security-related changes
        'security',
        // Code style changes (e.g., formatting)
        'style',
        // Adding or updating tests
        'test',
        // Work in progress (not ready for production)
        'wip',
      ]
    ]
  }
};

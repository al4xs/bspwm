**Description:**
Hi team,

It was found git exposed in one of your web assets

Git metadata directory (.git) was found in this folder. An attacker can extract sensitive information by requesting the hidden metadata directory that version control tool Git creates. The metadata directories are used for development purposes to keep track of development changes to a set of source code before it is committed back to a central repository (and vice-versa). When code is rolled to a live server from a repository, it is supposed to be done as an export rather than as a local working copy, and hence this problem.


## References

## Impact

Information Disclosure of All Source Code

## Steps to Reproduce
1. Access the url `{{data}}`
2. See the .git/ directory leaked

## Suggested Mitigation/Remediation Actions

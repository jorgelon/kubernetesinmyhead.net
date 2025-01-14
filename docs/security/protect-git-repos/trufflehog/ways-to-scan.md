# Ways to scan with trufflehog

If we want to scan git repositories with trufflehog we have some options:

> This article is based in trufflehog 3.82.13

## At filesystem level

The following command scans for credentials in a path, and we can use a cloned repo, but probably it is not the best option to scan a git repository because it does not scans the full git history.

```shell
trufflehog filesystem OPTIONS PATH
```

## At git level

The following command scans for credentials in a git repository, including all branches and commit history.

```shell
trufflehog git OPTIONS URL
```

- The url can be in https://, file://, or ssh:// format
- The --branch=BRANCH permits to set an specified branch
- --max-depth=DEPTH limits the commits to be scanned
- --since-commit=COMMIT also limits the commits to be scanned

## At provider level

We can scan for credentials in a in github or gitlab repository. It is similar to the git command, but includes additional options in every provider.

```shell
trufflehog github
```

```shell
trufflehog gitlab
```

There is an experimental github scan

```shell
trufflehog github-experimental
```

In both providers we can:

- Configure the github|gitlab server with the --endpoint=<https://whatever> option
- Tell trufflehog what repos we want to scan, we can repeat the --repo=REPO option with all the desired repos
- The authentication can be provided with the --token=TOKEN option or via the GITHUB_TOKEN or GITLAB_TOKEN environment variable

In github there are some specific github options that permit to tell the organization, the member repositories, if include or not forks, if include or not wikis,...

Also the output can be in a github actions format.

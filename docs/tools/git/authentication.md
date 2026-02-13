# Authentication with remotes

There are 2 ways to authenticate to a git repository depending on how the remote is configured.

## Git remote management

```shell
git config --get remote.origin.url                                        # check current URL
git remote set-url origin git@provider.com:organization/repository.git    # switch to SSH
git remote set-url origin https://provider.com/organization/repository.git # switch to HTTPS
git remote add upstream https://provider.com/organization/repository.git  # add a new remote
```

## Via SSH

The remote uses this format:

```txt
git@provider.com:organization/repository.git
```

This authentication mode relies on a SSH key loaded in memory (`ssh-agent` or similar) and imported in the provider's profile.

Generate a key, load it, and add the public key (`~/.ssh/id_ed25519.pub`) to the provider profile:

```shell
ssh-keygen -t ed25519 -C "your-email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh -T git@github.com  # test the connection
```

To use different keys per host, configure `~/.ssh/config`:

```txt
Host github.com
  IdentityFile ~/.ssh/id_ed25519_github
Host gitlab.com
  IdentityFile ~/.ssh/id_ed25519_gitlab
```

## Via HTTPS

The remote uses this format:

```txt
https://provider.com/organization/repository.git
```

In this case we need to provide username and password/token in our operations.

### Token-based authentication

Most providers require or recommend tokens instead of passwords:

- **GitHub**: Password auth is not supported. Use a Personal Access Token (PAT) created at <https://github.com/settings/tokens>
- **GitLab**: Use a Personal Access Token created at `Settings > Access Tokens`
- **Bitbucket**: Use an App Password created at `Personal settings > App passwords`

### Embedding credentials in the URL

It is possible to embed the token in the remote URL (not recommended for shared machines):

```shell
git remote set-url origin https://<username>:<token>@provider.com/org/repo.git
```

### Using .netrc

Credentials can be stored in `~/.netrc` (Linux/macOS) or `~/_netrc` (Windows). Ensure `chmod 600 ~/.netrc`:

```txt
machine github.com
login <username>
password <token>
```

## Credentials helper (HTTPS only)

To avoid being asked for credentials on every HTTPS operation, use a credential helper.

### Built-in helpers

```shell
git config --global credential.helper 'cache --timeout=3600'  # cache in memory (default 900s)
git config --global credential.helper store                    # store in ~/.git-credentials
```

> **Warning**: The `store` helper saves credentials in plain text. Use it only on trusted machines.

### Platform-specific helpers

These helpers integrate with the OS-level keystore for secure persistent storage:

| Platform | Helper                       | Backend                                        |
|----------|------------------------------|------------------------------------------------|
| Linux    | `git-credential-libsecret`   | GNOME Keyring / KWallet via libsecret          |
| macOS    | `git-credential-osxkeychain` | macOS Keychain (included with Xcode CLI tools) |
| Windows  | `git-credential-wincred`     | Windows Credential Manager                     |

Configure them:

```shell
# macOS
git config --global credential.helper osxkeychain
# Windows
git config --global credential.helper wincred
```

On Ubuntu/Debian, `git-credential-libsecret` is not pre-built. Build it from git contrib sources:

```shell
sudo apt-get install -y make gcc libsecret-1-0 libsecret-1-dev libglib2.0-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret
git config --global credential.helper \
  /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
```

On Fedora/RHEL, install the `git-credential-libsecret` package directly.

### Git Credential Manager (GCM)

Cross-platform alternative that supports OAuth, PATs, and MFA. Recommended over the platform-specific helpers above.

<https://github.com/git-ecosystem/git-credential-manager/>

```shell
git config --global credential.helper manager
```

### Provider CLIs

Both GitHub and GitLab CLIs can act as credential helpers for their respective platforms:

```shell
# GitHub CLI
gh auth login && gh auth setup-git
# GitLab CLI (glab)
glab auth login && glab auth setup-git
```

## Links

- [Git credentials](https://git-scm.com/docs/gitcredentials)
- [GitHub: Set up Git](https://docs.github.com/en/get-started/git-basics/set-up-git)
- [GitHub: About remote repositories](https://docs.github.com/en/get-started/git-basics/about-remote-repositories)
- [GitHub: Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub: Caching your GitHub credentials in Git](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)
- [GitLab: Personal access tokens](https://docs.gitlab.com/user/profile/personal_access_tokens/)

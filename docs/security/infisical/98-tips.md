# Tips

## Error "Unsupported state or unable to authenticate data"

- Link
<https://github.com/Infisical/infisical/issues/2005>

The only way I've been able to change the encryption keys so far is to delete the containers, images, and volumes related to infisical in Docker Desktop, and run docker compose up with the desired keys in .env to rebuild the entire system from scratch. I didn't see any other way in documentation or browsing online.

## Get stable releases

The versioning has changed over time.

- First releases using semver are only searcing all tags

```shell
curl -s "https://api.github.com/repos/Infisical/infisical/git/refs/tags" |  jq -r '.[].ref' | grep -v nightly | grep -v postgre | sed 's|refs/tags/||'
```

- Some releases had -postgres suffix. This stopped at v0.147.0 release. See <https://github.com/Infisical/infisical/releases/tag/v0.147.0>

```shell
curl -s "https://api.github.com/repos/Infisical/infisical/git/refs/tags" |  jq -r '.[].ref' | grep postgres | sed 's|refs/tags/||'
```

- GitHub Releases

Now they use github releases

```shell
curl -s "https://api.github.com/repos/Infisical/infisical/releases?per_page=100" | jq -r '.[].tag_name' | grep -E '^v0\.[0-9]+\.[0-9]+$'
```

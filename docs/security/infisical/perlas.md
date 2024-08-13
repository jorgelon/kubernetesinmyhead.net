# Perlas

## Error "Unsupported state or unable to authenticate data"

- Link
<https://github.com/Infisical/infisical/issues/2005>

The only way I've been able to change the encryption keys so far is to delete the containers, images, and volumes related to infisical in Docker Desktop, and run docker compose up with the desired keys in .env to rebuild the entire system from scratch. I didn't see any other way in documentation or browsing online.

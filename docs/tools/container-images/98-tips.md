# Tips

## Add Maintainer to Dockerfile

Use the LABEL instruction

```txt
LABEL maintainer="<your-email@example.com>"
```

  Or with more detail:

```txt
LABEL maintainer="Your Name <your-email@example.com>"
```

> Note: The old MAINTAINER instruction is deprecated.

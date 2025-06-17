# Dockerfile reference

## ONBUILD

With the ONBUILD instruction we can setup actions that will not be executed when building the current Dockerfile. It will only be executed when the image is used as the base for another build

# Errors

## Only dynamically provisioned pvc

only dynamically provisioned pvc can be resized and the storageclass that provisions the pvc must support resize

Solution: If storageclass supports resize, add allowVolumeExpansion: true to the storageclass

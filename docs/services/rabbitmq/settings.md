# Settings

## Memory

<https://www.rabbitmq.com/docs/memory>

example:

```txt
vm_memory_high_watermark.absolute = 450Mi
```

## Disk

<https://www.rabbitmq.com/docs/disk-alarms>

example:

```txt
disk_free_limit.absolute = 512MB
```

## Partition handling

Strategies:

- pause-minority
- pause-if-all-down mode
- autoheal
- ignore

<https://www.rabbitmq.com/docs/partitions>

```txt
cluster_partition_handling = autoheal
```

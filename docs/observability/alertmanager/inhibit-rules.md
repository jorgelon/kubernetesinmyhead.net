# Inhibit rules

A Prometheus inhibit rule is a configuration in Alertmanager that prevents certain alerts from firing when other higher-priority or related alerts are already active. It's a way to reduce alert noise by suppressing redundant or less important notifications.

## Structure

In an inhibit rule we must define:

- Source alerts

They are alerts that will supress other alerts when active.

- Target alerts:

They are the alerts that will be suppressed when source alerts match

## Example cases

- Supress alerts related with diskspace, cpu usage or memory usage when the node is down
- Supress warning alerts when critical alerts are firing about the same topic
- Supress a less important alert when a more important alert. For example, don't alert an application is down when its loadbalancer is down, that causes the application is down

> In prometheus operator this can be achieved using an AlertmanagerConfig kubernetes resource spec.inhibitRules

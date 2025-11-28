# Tips

## Default credentials

We can log in with the following credentials:
Username: admin
Password: Harbor12345

## Basic Harbor settings

This settings provide a good starting point to configure the defalt VMware Harbor deployment

- Consider quota
- Schedule a scan
- Configure garbage collection
- Disable self registration
- Restrict project creation
- make robot username unpredictable
- Disable Webhooks

Under Project Quotas

- Consider to enable "Default quota space per project"

Under Interrogation Services - Vulnerability

- Configure "Schedule to scan all"

Under Clean Up

- Schedule a garbage collection
- Enable "Allow garbage collection on untagged artifacts"
- Enable a log rotation

Under Configuration-Authentication

- disable "Allow Self-Registration"

Under Configuration-System Settings

- leave "Project Creation" to "Admin Only"
- change the "Robot Name Prefix"
- uncheck "Webhooks Enabled"

## Consider this project scoped settings

This settings provide a good starting point to configure every vmware harbor project

- Avoid public repositories
- Enabling "Automatically scan images on push"
- Enabling checking of verified images
- Enabling "Prevent vulnerable images from running"
- Enabling quota

## About users and robot accounts

- use robot accounts for applications
- use users for humans
- give the minimal permissions to them
- tend to use scoped users/robot accounts
- create global users/robot accounts only when needed

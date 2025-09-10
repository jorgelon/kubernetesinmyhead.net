# Tips

## Policy

We can control how the dns records are syncronized between sources and providers with the policy.

Via policy, we can control if the controller can update records when the ingress or services annotations change, or remove records when they are deleted

| Policy      | Create | Update | Remove |
|-------------|--------|--------|--------|
| upsert-only | Yes    | Yes    | No     |
| create-only | Yes    | No     | No     |
| sync        | Yes    | Yes    | Yes    |

> upsert-only is the default behaviour

## Share zones between clusters

External dns can dinamically create and remove dns entries in the provider when services and ingress resources with certain configurations are added and removed (sync policy)

We can also manage the same zone from more than one kubernetes cluster, but this have a potential problem.

External secrets by default uses txt dns entries for tracking the ownership of DNS entries. This makes external-dns will only remove entries it manages.

> This defalt behaviour can be changed changing "registry" setting from "txt" to "aws-sd", "dynamodb" or "noop".

But if we share the same --txt-owner-id between clusters, both controllers will create entries in that zones but both will think they own all records in that zone. This can cause several problems.

The solution is to use different --txt-owner-id per external-dns controller.

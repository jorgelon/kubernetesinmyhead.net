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

**For AWS Route53**: The txtOwnerId should be the Hosted Zone ID (e.g., Z1D633PJN98FT9).

**For multi-cluster setups with Route53**: Since txtOwnerId must be the Hosted Zone ID, **sharing the same Route53 zone between multiple external-dns controllers is NOT recommended** when using the default "txt" registry. All controllers would use the same txtOwnerId, causing ownership conflicts and unpredictable behavior.

**Recommended approaches for multi-cluster Route53 setups**:

1. **Separate hosted zones**: Give each cluster its own subdomain zone

   ```yaml
   # Cluster 1
   domainFilters: ["cluster1.example.com"]
   txtOwnerId: Z1D633PJN98FT9
   
   # Cluster 2  
   domainFilters: ["cluster2.example.com"]
   txtOwnerId: Z2E744QKM09GHI
   ```

2. **Use aws-sd registry**: Switch from "txt" to "aws-sd" registry

   ```yaml
   registry: aws-sd
   ```

3. **Use noop registry**: Disable ownership tracking (loses safety features)

   ```yaml
   registry: noop
   ```

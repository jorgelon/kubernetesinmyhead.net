# Contour to Envoy Gateway Migration Path

## Overview

VMware Contour, a CNCF Incubating project, has announced a strategic migration path toward Envoy Gateway, a new CNCF project designed to consolidate the fragmented landscape of Envoy-based ingress controllers. This document outlines the migration strategy, timeline, and resources for developers transitioning from Contour to Envoy Gateway.

## Background

In May 2022, VMware announced that Contour would join forces with community leaders including Tetrate and Ambassador to build the new **Envoy Gateway** project under the Envoy banner. This initiative aims to create a single, cohesive, canonical implementation of a Kubernetes Gateway API reference implementation.

## Migration Strategy

### Current Status

* **Contour Development**: Continues with current release cadence and support policy
* **Gateway API Development**: VMware's Gateway API development efforts have moved to Envoy Gateway
* **Contour's Gateway API**: Remains in experimental state
* **Feature Development**: VMware continues feature development on Contour for existing users

### Long-term Direction

* **Evolutionary Migration**: The transition is designed to be gradual, not immediate
* **Feature Parity Requirement**: Migration evaluation is postponed until Envoy Gateway achieves feature parity with Contour
* **User Protection**: Existing Contour users remain fully supported throughout the transition

## Migration Tools and Support

### Planned Migration Tooling

* **HTTPProxy to Gateway API**: Conversion tools to migrate from Contour's HTTPProxy resource to Gateway API
* **Configuration Migration**: Tooling to help migrate existing configurations
* **Feature Gap Analysis**: Tools to identify features not yet supported by Gateway API

### Feature Considerations

Current HTTPProxy functionality not yet available in Gateway API:

* Rate limiting
* Authentication mechanisms
* Advanced routing features
* Custom middleware integrations

## Timeline and Roadmap

### Short Term (Current)

* Contour maintains full development and support
* Users can continue using Contour without disruption
* Gateway API remains experimental in Contour

### Medium Term

* Envoy Gateway development continues toward feature parity
* Migration tooling development
* Community feedback and testing

### Long Term

* Evaluation of Contour's direction as Envoy Gateway matures
* Potential transition of users to Envoy Gateway
* Contour may become a wrapper around Envoy Gateway core

## Benefits of Migration

### For Developers

* **Simplified API**: Easier adoption of Envoy as API gateway "out of the box"
* **Standardization**: Single canonical implementation reduces fragmentation
* **Community Support**: Broader community backing under CNCF
* **Gateway API Native**: Built from ground up for Kubernetes Gateway API

### For Organizations

* **Reduced Maintenance**: Consolidated project reduces operational overhead
* **Better Interoperability**: Standard implementation improves compatibility
* **Long-term Support**: CNCF governance provides sustainability
* **Vendor Neutrality**: Community-driven development model

## Current Recommendations

### For New Projects

* **Evaluate Envoy Gateway**: Consider starting with Envoy Gateway for new deployments
* **Monitor Development**: Track Envoy Gateway's feature development progress
* **Test Migration Tools**: Participate in migration tooling beta testing

### For Existing Contour Users

* **Continue Current Usage**: No immediate action required
* **Plan for Future**: Begin planning migration strategy for long-term
* **Stay Informed**: Monitor announcements from both projects
* **Test Compatibility**: Evaluate current configurations against Gateway API

## Resources and Links

### Official Announcements

* [Contour Joins Forces With Community Leaders to Build New Envoy Gateway Project](https://blogs.vmware.com/opensource/2022/05/16/contour-and-community-build-new-envoy-gateway/) - VMware Open Source Blog
* [Introducing Envoy Gateway](https://www.cncf.io/blog/2022/05/16/introducing-envoy-gateway/) - CNCF Blog
* [VMware Hands Control of Kubernetes Ingress Controller Contour to CNCF](https://www.datacenterknowledge.com/vmware/vmware-hands-control-kubernetes-ingress-project-contour-over-cncf) - Data Center Knowledge

### Project Resources

* [Project Contour](https://projectcontour.io/) - Official Contour Website
* [Contour CNCF Project Page](https://www.cncf.io/projects/contour/) - CNCF
* [Envoy CNCF Project Page](https://www.cncf.io/projects/envoy/) - CNCF

### Technical Documentation

* [Mapping out the future of cluster ingress with Contour and Gateway API](https://www.cncf.io/blog/2021/04/27/mapping-out-the-future-of-cluster-ingress-with-contour-and-gateway-api/) - CNCF Blog
* [VMware Tanzu Platform Service Routing with Contour](https://tanzu.vmware.com/developer/guides/service-routing-contour-refarch/) - VMware Tanzu

### Industry Analysis

* [Envoy Gateway Makes Using Envoy Proxy Easier for Developers](https://tetrate.io/press/steering-committee-commits-to-envoy-gateway) - Tetrate
* [VMware's Contour becomes the CNCF's latest incubation-level project](https://siliconangle.com/2020/07/07/vmwares-contour-becomes-cncfs-latest-incubation-level-project/) - SiliconANGLE

## Conclusion

The migration from Contour to Envoy Gateway represents a strategic consolidation in the Envoy-based ingress controller ecosystem. While the transition is evolutionary and long-term, developers should begin familiarizing themselves with Envoy Gateway and planning for eventual migration. VMware's commitment to providing migration tools and maintaining Contour support ensures a smooth transition path for existing users.

The success of this migration depends on Envoy Gateway achieving feature parity with Contour and the development of robust migration tooling. Organizations should monitor both projects' progress and participate in community testing to ensure their specific use cases are supported in the migration path.

# AlertmanagerConfig v1beta1

Does AlertmanagerConfig v1beta1 exists?

- v1beta1 was announced but not fully deployed:
  
The prometheus-operator team announced v1beta1 for AlertmanagerConfig in version 0.57.0 (June 2022), but it was implemented as an opt-in feature requiring conversion webhooks.

- Default CRDs still use v1alpha1

The standard CRD files in example/prometheus-operator-crd/ directory only contain v1alpha1. The v1beta1 version would be in example/prometheus-operator-crd-full/ but requires additional webhook setup.

- Documentation vs. Reality Gap:

- OpenShift/OKD documentation shows v1beta1 because they have their own implementation
- The official prometheus-operator CRDs in their GitHub repo still primarily use v1alpha1
- Third-party CRD catalogs (like Datree's) follow the standard CRDs, hence only v1alpha1

> Current Status: The v1beta1 API exists in the codebase but is not the default deployment method. Most users continue using v1alpha1.

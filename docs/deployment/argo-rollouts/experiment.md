# Experiments

An Experiment is limited run of one or more ReplicaSets for the purposes of analysis. Experiments typically run for a pre-determined duration, but can also run indefinitely until stopped. Experiments may reference an AnalysisTemplate to run during or after the experiment. The canonical use case for an Experiment is to start a baseline and canary deployment in parallel, and compare the metrics produced by the baseline and canary pods for an equal comparison.

<https://argo-rollouts.readthedocs.io/en/stable/features/experiment/>

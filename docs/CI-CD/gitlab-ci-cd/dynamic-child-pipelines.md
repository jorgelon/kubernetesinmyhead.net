# Dynamic child pipelines

Dynamic child pipelines are created dynamically from a previous job.

We have 3 steps:

## Pipeline generation

A job creates one or more pipelines in the git repository and save them in an artifact

```yaml
pipeline-generation:
  stage: build
  script: create-pipelines.sh > pipelines.yml
  artifacts:
    paths:
      - pipelines.yml
```

## Dynamic Child pipelines

These are the dynamic pipelines generated in the parent job

Here $CI_PIPELINE_SOURCE always has the value of "parent_pipeline" so we must limit the execution of this job with it

```yaml
job1:
  rules:
    - if: $CI_PIPELINE_SOURCE == "parent_pipeline"
```

## Child (downstream) job

This is the job that with a trigger that receives the Dynamic Child pipelines as artifacts from the trigger job.

```yaml
child:
  trigger:
    include:
      - artifact: pipelines.yml
        job: pipeline-generation
```

## Links

- Dynamic child pipelines

<https://docs.gitlab.com/ci/pipelines/downstream_pipelines/#dynamic-child-pipelines>

- Create child pipelines using dynamically generated configurations

<https://www.youtube.com/watch?v=nMdfus2JWHM>

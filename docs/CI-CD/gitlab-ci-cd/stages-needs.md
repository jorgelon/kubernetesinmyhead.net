# Stages and needs

The stages permit to group gitlab CI/CD jobs

## Defining the stages

The default stages are

- .pre
- build
- test
- deploy
- .post

They can be redefined in the .gitlab-ci.yml file

```yaml
stages:
  - mystage1
  - mystage2
  - mystage3
```

> If a stage is defined but no jobs use it, the stage is not visible in the pipeline

## Defining the stage of a job

We define inside a job the stage belongs to.

```yaml
myjob:
  stage: mystage1
```

> If no stage is defined, the job uses the test stage by default

## How the stages run

- If a pipeline contains only jobs in the .pre or .post stages, it does not run. There must be at least one other job in a different stage.
- All the jobs in the same stage runs in parallel
- When all jobs in an stage succeed, the next stage jobs start.
- When all stages succeed, the pipeline is marked as passed
- If any job fails, the pipeline is marked as failed and jobs in later stages do not start. Jobs in the current stage are not stopped and continue to run.

## Needs

Pending

<https://docs.gitlab.com/ci/yaml/#needs>

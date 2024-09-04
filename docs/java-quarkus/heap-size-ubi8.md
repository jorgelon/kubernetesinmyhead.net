# Max heap size in openjdk ubi8

If we want to define the max heap size in a container using openjdk ubi8 container image we must take care about this.

The most modern way to setting the max heap size is using the MaxRAMPercentage value, using cgroups v2. This leaves the tipical -Xmx option deprecated.

- [rhel-8] replace use of JVM flag -Xmx with -XX:MaxRAMPercentage  
<https://issues.redhat.com/browse/OPENJDK-1486>

The jvm is container aware and Openjdk has a default max heap size of 25% of the memory assigned, memory limit of the container in kubernetes environments.

Redhat changed that too low settings in their ubi 8 images to the 50% of the resource-limits defined in the container and in 2023 they increased that value to 80.0

- The redhat advisory  
<https://access.redhat.com/errata/RHEA-2023:4785>

- ...including the increase to 80%  
<https://issues.redhat.com/browse/OPENJDK-1982>

- ... was included in the redhat ubi8 1.17-1 tag  
<https://catalog.redhat.com/software/containers/ubi8/openjdk-17/618bdbf34ae3739687568813/?image=64dca15f28942e2b8ce820fc&architecture=amd64>

> If you dont like the 80.0 default value, you can use the JAVA_MAX_MEM_RATIO environment variable.

## Some notes

- Exec
That container does not executre the tipical java -jar. There are several scripts involved in the container. The entrypoint is /usr/local/s2i/run and to get the final command we see the log

```shell
kubectl get pod
read -p "Tell me the desired pod: " POD
kubectl logs ${POD}| grep "INFO exec"
```

- Memory limit

To check jvm sees the memory limit of the container

```shell
kubectl get pod
read -p "Tell me the desired pod: " POD
kubectl exec ${POD} -- java -XshowSettings:system -version
```

- Checking the values the wrong way

Warning, this shows the default values, not the runtime values

```shell
kubectl get pod
read -p "Tell me the desired pod: " POD
kubectl exec ${POD} -- java -XX:+PrintFlagsFinal -version | egrep -e 'UseContainerSupport|HeapSize|MaxRAMPercentage'
kubectl exec ${POD} -- java -XshowSettings:vm -version
```

## Other Links

- What's new in the Red Hat UBI OpenJDK containers  
<https://developers.redhat.com/articles/2023/07/19/whats-new-red-hat-ubi-openjdk-containers>

- Overhauling memory tuning in OpenJDK containers updates  
<https://developers.redhat.com/articles/2023/03/07/overhauling-memory-tuning-openjdk-containers-updates#what_to_expect_in_the_next_container_update>

- How to use Java container awareness in OpenShift 4  
<https://developers.redhat.com/articles/2024/03/14/how-use-java-container-awareness-openshift-4#>



En argo workflows, los templates se traducen diferentes pods, que no comparten nada.

Si queremos que, por ejemplo, compartan un volumen montado, hay varias opciones:

- Definiendo en el spec del workflow un volumen

https://argo-workflows.readthedocs.io/en/stable/fields/#volume

- Definiendo en el spec del workflow un PersistentVolumeClaim

https://argo-workflows.readthedocs.io/en/stable/fields/#persistentvolumeclaim

- Usar containerSet

https://argo-workflows.readthedocs.io/en/stable/container-set-template/

Un problema con containerSet es que pierdes la ventaja de los workflowtemplates pero obtienes un almacenamiento mas barato con emptyDir.

- Mediante initContainers

https://argo-workflows.readthedocs.io/en/latest/fields/#usercontainer

- Mediante inputs - artifacts

Tambien podemos usar artifacts como inputs si lo que queremos hacer con alguno de esos containers cuadra con ello. Por ejemplo, traernos un repo de git o similar, aunque es una forma mas dogmatica.

https://argo-workflows.readthedocs.io/en/latest/fields/#artifact
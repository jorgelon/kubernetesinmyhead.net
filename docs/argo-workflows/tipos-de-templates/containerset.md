# Containerset

El tipo de template containerSet permite que varias contenedores se levanten dentro del mismo pod, lo que le permite beneficiarse de lo que ofrece un pod, en terminos de compartir host, red y almacenamiento. Por ejemplo, es una buena forma de compartir volumen sin necesidad de usar persistenvolumeclaims o similar, sino emptyDir.

retryStrategy

Sin embargo tiene algunas limitaciones:

- Aunque tiene un sistema de dependencias, para usarlo te fuerza a utilizar el emmissary executor y no se puedan usar "enhanced depencies logic"
- Solo puede cargarse inputs y outputs de un contenedor llamado main, al igual que en templates de tipo container y scripts
- If you want to use base-layer artifacts, main must be last to finish, so it must be the root node in the graph.
That may not be practical.
Instead, have a workspace volume and make sure all artifacts paths are on that volume.
- En terminos de consumo de recursos puede no ser eficiente ya que se inician todos los contenedores y aunque uno haya terminado su operacion, siempre esta consumiendo algo. Ademas los requests seran la suma de los requests de todos los contenedores.

> Un truco seria calcular el momento de mayor consumo del containerSet y repartir esos valores entre los requests de los containers

## Links

- Containerset  
<https://argo-workflows.readthedocs.io/en/stable/container-set-template/>

- Containerset fields  
<https://argo-workflows.readthedocs.io/en/stable/fields/#containersettemplate>

- Enhanced Depends Logic  
<https://argo-workflows.readthedocs.io/en/stable/enhanced-depends-logic/>

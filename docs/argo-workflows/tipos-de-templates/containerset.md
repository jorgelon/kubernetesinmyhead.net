# Containerset

El tipo de template containerSet permite que varias contenedores se levanten dentro del mismo pod, lo que le permite beneficiarse de lo que ofrece un pod, en terminos de compartir host, red y almacenamiento. Por ejemplo, es una buena forma de compartir volumen sin necesidad de usar persistenvolumeclaims o similar, sino emptyDir.

Sin embargo tiene algunas limitacines y o caracteristicas:

- Tiene disponible un sistema sencillo de depencias
- Solo se puede usar el executor emissary si se quieren usar dependencias
- No se puede usar enhanced depencies logic

## Links

- Containerset  
<https://argo-workflows.readthedocs.io/en/stable/container-set-template/>

- Containerset fields  
<https://argo-workflows.readthedocs.io/en/stable/fields/#containersettemplate>

- Enhanced Depends Logic  
<https://argo-workflows.readthedocs.io/en/stable/enhanced-depends-logic/>

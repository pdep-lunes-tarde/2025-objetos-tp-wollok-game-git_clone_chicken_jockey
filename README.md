# Grupo

Nombre: **git_clone_chicken_jockey**

Integrantes
- Francisco Der Ghougassian
- Facundo Harche
- Thiago Piccoli
- Emanuel Prima

# Consigna TP Integrador

Hacer un juego aplicando los conceptos de la materia.
El TP debe:
- aplicar los conceptos que vemos durante la materia.
- tener tests para las funcionalidades que definan.
- evitar la repetición de lógica.

# Como correrlo

Con la extensión de VSCode, pararse sobre el program y correr `Run Game`

![image](https://github.com/user-attachments/assets/532b04d4-dca8-4887-aa47-a3c631b42568)

También, se puede correr desde la terminal como:
```
wollok run juego.juego --skipValidations --port 4200 -p RUTA_AL_PROYECTO
```


# Entregas

## Checkpoint 1 (se corrige de manera asincrónica): 13/10

Para el 13/10 debe estar subido en el repo el nombre, descripción y controles de su juego (editen este archivo en la sección **Juego** al final) y el código de lo que tengan hasta el momento.

Para esta entrega la idea es que esté definida la idea del juego a realizar, y que tengan al menos:
- alguna forma en la que el jugador pueda interactuar (ya sea un personaje controlado, un menú, etc).
- una forma de ganar o de perder, con el resultado de eso (pantalla de game over/reseteo del estado del juego/etc).

De esa entrega vamos a ayudarles a decidir que agregar para la siguiente entrega.

## Entrega y corrección presencial: 27/10

En esta entrega se evaluará el uso de objetos en el tp. Debe haber presente al menos una persona del grupo ese día para la corrección, caso contrario se considera no entregado.

# Juego: Dungeon Hunter

![logo](logo.png)

En este juego, uno es un personajito que se encuentra en una mazmorra donde tiene el objetivo de encontrar la mayor cantidad de tesoros posibles a cada paso que da. 
Sin embargo, no está solo, y cada tanto aparecen un enemigos que vienen a eliminarlo. Consigue la mayor cantidad oro posible antes de que los mosntruos te atrapen!

Controles del aventurero:
  Flechas: moverse de manera convencional.
  WASD: para atacar en multiples direcciones
  Spawn y movimiento de los enemigos/items:
  Lo ideal sería que por cada interacción que el usuario haga, los enemigos avancen. Cada cierta cantidad de interacciones, aparece un enemigo.
  Lo mismo con los tesoros, cada 5 pasos, que aparezca una moneda o un tesoro más grande.

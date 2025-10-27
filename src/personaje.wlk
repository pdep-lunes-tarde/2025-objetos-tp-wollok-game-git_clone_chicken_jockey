import textos.*
import tp.configurar_juego

object pj {
    var property position = game.center()
    var property vida = 3
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 0
    var property enemigos_asesinados = 0 
    var property invulnerable = false
    var atacando = false
    var property ultima_posicion = position

    var property image = "Soldado_idle.png"

    method arriba() {
        if (position.y() <= configurar_juego.alto() - 2 && ( game.getObjectsIn(position.up(1)).isEmpty() || !game.getObjectsIn(position.up(1)).first().debo_retroceder())) { // el numero es para que se vea, varia segun el tamanio de las celdas
            ultima_posicion = position
            position = position.up(1)
        }
    }

    method abajo() {
        if (position.y() >= 0 && ( game.getObjectsIn(position.down(1)).isEmpty() || !game.getObjectsIn(position.down(1)).first().debo_retroceder())) {
            ultima_posicion = position
            position = position.down(1)
        }
    }

    method derecha() {
        if (position.x() <= configurar_juego.ancho() - 2 && ( game.getObjectsIn(position.right(1)).isEmpty() || !game.getObjectsIn(position.right(1)).first().debo_retroceder())) { // el numero es para que se vea, varia segun el tamanio de las celdas
            ultima_posicion = position
            position = position.right(1)
        }
    }

    method izquierda() {
        if (position.x() >= 0 && ( game.getObjectsIn(position.left(1)).isEmpty() || !game.getObjectsIn(position.left(1)).first().debo_retroceder())){
            ultima_posicion = position
            position = position.left(1)
        }
    }

    method es_movimiento_valido(nueva_posicion) {
        return nueva_posicion.x() >= 0 && nueva_posicion.x() < configurar_juego.ancho() &&
               nueva_posicion.y() >= 0 && nueva_posicion.y() < configurar_juego.alto()
    }

    method centrate() {
        position = game.center()
    }

    method animacion_ataque(direccion) {

    const duracion_total = 500
    const duracion_frame = duracion_total.div(4)
    atacando = true
    game.schedule(duracion_total, { atacando = false })

        game.schedule(0, {image = "Soldado_ataque_0.png"})

        if (direccion != null) {
            const pos = if (direccion == "derecha") position.right(1) else if (direccion == "izquierda") position.left(1) else if (direccion == "arriba") position.up(1) else position.down(1)

            const imagen0 = "Soldado_efecto_ataque_" + direccion + "_0.png"
            const imagen1 = "Soldado_efecto_ataque_" + direccion + "_1.png"

            game.schedule(duracion_frame, {
                const efecto0 = new Imagen_efecto_ataque(position = pos, image = imagen0)
                efecto0.aparece()
                game.schedule(duracion_frame, { game.removeVisual(efecto0) })
            })

            game.schedule(duracion_frame * 2, {
                const efecto1 = new Imagen_efecto_ataque(position = pos, image = imagen1)
                efecto1.aparece()
                game.schedule(duracion_frame, { game.removeVisual(efecto1) })
            })
        }

        game.schedule(duracion_frame * 3, {image = "Soldado_ataque_3.png"})
        game.schedule(duracion_frame * 4, {image = "Soldado_idle.png"})
    }

    method posicion_menu() {
        self.centrate()
        position = position.left(9)
    }

    method atacar_arriba() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(0)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().up(1)) })
        if (!atacando) {
            self.animacion_ataque("arriba")
        }
    }

    method atacar_abajo() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(1)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().down(1)) })
        if (!atacando) {
            self.animacion_ataque("abajo")
        }
    }

    method atacar_izquierda() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(2)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().left(1)) })
        if (!atacando) {
            self.animacion_ataque("izquierda")
        }
    }
    
    method atacar_derecha() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(3)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().right(1)) })
        if (!atacando) {
            self.animacion_ataque("derecha")
        }
    }
    
    method sumar_puntuacion(puntos_a_sumar) {
        puntuacion += puntos_a_sumar
        if (puntuacion >= 3) {
            self.subir_nivel()
        }if (nivel >= 3){
            configurar_juego.gane()
        }
    }

    method subir_nivel() {
            danio += 1
            nivel += 1
            puntuacion = 0
    }

    method posiciones_alrededor() {
        return [position.up(1), position.down(1), position.left(1), position.right(1)]
    }

    method mataste_un_ogro() {
        configurar_juego.agregar_objeto_aleatorio()
        self.sumar_puntuacion(1)
        enemigos_asesinados += 1
    }

    method fuiste_atacado(enemigo) {
        vida -= enemigo.danio()
        barra_de_vida.restar_vida()
        if (vida <= 0) {
            self.moriste()
        }
        self.animacion_fuiste_atacado()
    }

    method moriste() {
    const duracion_total = 1000
    const duracion_frame = duracion_total.div(3)

        // Frame 0
        game.schedule(duracion_frame, {image = "Soldado_muerte_0.png"})
        game.schedule(duracion_frame * 2, {image = "Soldado_muerte_1.png"})
        game.schedule(duracion_frame * 3, {image = "Soldado_muerte_2.png"})
        game.schedule(duracion_frame * 4, {configurar_juego.perdi()})     
        
    }

    method animacion_fuiste_atacado() {
    const duracion_total = 500
    const duracion_frame = duracion_total.div(2)

        game.schedule(0, {image = "Soldado_lastimado_0.png"})
        game.schedule(duracion_frame, {image = "Soldado_lastimado_1.png"})
        game.schedule(duracion_frame * 2, {image = "Soldado_idle.png"})
    }
    
    method recibir_vida() {
        if (vida < 5) {
            vida += 1
            barra_de_vida.sumar_vida()
        }
    }

    method reiniciate() {
        vida = 3
        puntuacion = 0
        danio = 1
        nivel = 0
        self.centrate()
        atacando = false
        image = "Soldado_idle.png"
    }

    method debo_retroceder() {
        return false
    }

    method retrocede(otro) {
        position = ultima_posicion
    }
}
object barra_de_vida{
    var property corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                              new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                              new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    var property corazones_vacios = [new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                                     new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                                     new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]

    method restar_vida(){
        game.removeVisual(corazones.last())
        corazones.remove(corazones.last())
     
    }
    method sumar_vida(){      
        const nuevo_corazon = new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2 - corazones.size(), y = configurar_juego.alto() - 1))
        game.addVisual(nuevo_corazon)
        corazones.add(nuevo_corazon)   
    }
    method reiniciate(){
        corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    }
}

class Imagen_efecto_ataque {
    var property position
    var property image

    method aparece() {
        game.addVisual(self)
    }
}   
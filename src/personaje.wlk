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
    var property ultima_posicion = position

    method image() = "soldado_16.png"

    method arriba() {
        if (position.y() <= configurar_juego.alto() - 2 && ( game.getObjectsIn(position.up(1)).isEmpty() || !game.getObjectsIn(position.up(1)).first().debo_retroceder())) { // el numero es para que se vea, varia segun el tamanio de las celdas
            ultima_posicion = position
            position = position.up(1)
        }
    }

    method abajo() {
        if (position.y() >= 0 && ( game.getObjectsIn(position.up(1)).isEmpty() || !game.getObjectsIn(position.down(1)).first().debo_retroceder())) {
            ultima_posicion = position
            position = position.down(1)
        }
    }

    method derecha() {
        if (position.x() <= configurar_juego.ancho() - 2 && ( game.getObjectsIn(position.up(1)).isEmpty() || !game.getObjectsIn(position.right(1)).first().debo_retroceder())) { // el numero es para que se vea, varia segun el tamanio de las celdas
            ultima_posicion = position
            position = position.right(1)
        }
    }

    method izquierda() {
        if (position.x() >= 0 && ( game.getObjectsIn(position.up(1)).isEmpty() || !game.getObjectsIn(position.left(1)).first().debo_retroceder())){
            ultima_posicion = position
            position = position.left(1)
        }
    }

    method centrate() {
        position = game.center()
    }

    method posicion_menu() {
        self.centrate()
        position = position.left(9)
    }

    method atacar_arriba() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(0)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().up(1)) })
    }

    method atacar_abajo() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(1)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().down(1)) })
    }

    method atacar_izquierda() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(2)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().left(1)) })
    }
    
    method atacar_derecha() {
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(3)).forEach({ ogro => ogro.fuiste_atacado(self, ogro.position().right(1)) })
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
        self.sumar_puntuacion(1)
        enemigos_asesinados += 1
        configurar_juego.agregar_objeto_aleatorio()
    }

    method fuiste_atacado(enemigo) {
        vida -= enemigo.danio()
        if (vida <= 0) {
            configurar_juego.perdi()
        }
    }
    
    method recibir_vida() {
        if (vida < 5) {
            vida += 1
        }
    }

    method reiniciate() {
        vida = 3
        puntuacion = 0
        danio = 1
        nivel = 0
        self.centrate()
    }

    method debo_retroceder() {
        return false
    }

    method retrocede(otro) {
        position = ultima_posicion
    }
}

/*object barra_de_vida{
    var property corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)), new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)), new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    var property corazones_vacios = []

    method restar_vida(){
        const ultimo_corazon = corazones.last()
        const corazon_vacio = new Imagen_corazon_vacio(position = ultimo_corazon.position())
        self.actualizar_corazon_en_juego(corazon_vacio)
        corazones_vacios.remove(ultimo_corazon) 
        corazones_vacios.add(corazon_vacio)      

    }
    method sumar_vida(){      
        const ultimo_corazon_vacio = corazones_vacios.last()
        const corazon = new Imagen_corazon(position = ultimo_corazon_vacio.position())
        self.actualizar_corazon_en_juego(corazon)
        corazones_vacios.remove(ultimo_corazon_vacio) 
        corazones.add(corazon)      
    }

    method actualizar_corazon_en_juego(corazon_nuevo){
        const ultimo_corazon = corazones.last()
        game.removeVisual(ultimo_corazon)
        corazones.remove(ultimo_corazon)
        game.addVisual(corazon_nuevo)
        corazones.add(corazon_nuevo)
    }
    method reiniciate(){
        corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    }
}*/
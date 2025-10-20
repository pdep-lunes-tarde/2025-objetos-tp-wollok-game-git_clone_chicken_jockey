import textos.*
import tp.configurar_juego

object pj {
    var property position = game.center()
    var property vida = 3
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 0
    var property enemigos_asesinados = 0

    method image() = "manzana_16.png"

    method arriba() {
        if (position.y() <= configurar_juego.alto() - 2) { // el numero es para que se vea, varia segun el tamanio de las celdas
            position = position.up(1)
        }
    }

    method abajo() {
        if (position.y() >= 0) {
            position = position.down(1)
        }
    }

    method derecha() {
        if (position.x() <= configurar_juego.ancho() - 2) { // el numero es para que se vea, varia segun el tamanio de las celdas
            position = position.right(1)
        }
    }

    method izquierda() {
        if (position.x() >= 0){
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
    }

    method subir_nivel() {
        if (puntuacion == 3) {
            danio += 1
            nivel += 1
            puntuacion = 0
        }
    }

    method posiciones_alrededor() {
        return [position.up(1), position.down(1), position.left(1), position.right(1)]
    }

    method mataste_un_ogro() {
        self.sumar_puntuacion(1)
        self.subir_nivel()
        if (nivel >= 3) {
            configurar_juego.termino_el_juego()
            game.addVisual(you_win)
        }
        enemigos_asesinados += 1
    }

    method fuiste_atacado(enemigo) {
        vida -= enemigo.danio()
        if (vida <= 0) {
            configurar_juego.termino_el_juego()
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
}
import personaje.pj
import textos.Vida_enemigos
import tp.*

class Ogro {
    var property position = game.center()
    var property vida
    var property ultima_posicion = game.center()
    var property danio = 1
    var property texto_vida = new Vida_enemigos(enemigo = self)
    const lentitud = 0
    var property clock_movimientos = 0
    var property debo_mostrar_vida = true
    var primer_movimiento = true

    method image() = "Orco_16.png"

    method movete_a(nueva_direccion){
        const posicion_candidata = nueva_direccion.siguientePosicion(position)

        ultima_posicion = position
        position = posicion_candidata

        texto_vida.mover_con_enemigo()

    }

    method aparecer() {
        self.movete_a_posicion_aleatoria()
        configurar_juego.mostrar_ogro_y_vida(self)
    }

    method posicion_menu() { 
        self.centrate()
        position = position.right(9)
    }

    method movete_a_posicion_aleatoria() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height() - 2).truncate(0)
        position = game.at(x, y)
    }

    method centrate() {
        position = game.center()
    }

    method chocaste_con_pj() {
        pj.fuiste_atacado(self)
        self.retrocede(self)
    }

    method mover_hacia(target) {
        if (clock_movimientos == lentitud) {
            const direccion_a_moverse = self.determinar_movimiento_hacia(target)
            self.movete_a(direccion_a_moverse)

            clock_movimientos = 0
        } else clock_movimientos += 1

        if (debo_mostrar_vida != game.hasVisual(texto_vida)) {
            if (game.hasVisual(texto_vida)) game.removeVisual(texto_vida)
            else game.addVisual(texto_vida)
        }

        if(primer_movimiento) {
            primer_movimiento = false
            if (!debo_mostrar_vida) game.addVisual(texto_vida)
        }
    }

    method determinar_movimiento_hacia(target) = if (self.position().x() < target.position().x()) derecha
                                                 else if (self.position().x() > target.position().x()) izquierda
                                                 else if (self.position().y() > target.position().y()) abajo
                                                 else arriba

    method fuiste_atacado(enemigo, nueva_posicion) {
        vida -= enemigo.danio()
        if (vida <= 0) {
            debo_mostrar_vida = false
            game.removeVisual(self)
            game.removeVisual(texto_vida)
            pj.mataste_un_enemigo(self)
        } else {
            debo_mostrar_vida = true
            self.retrocede(self)
        }
    }

    method retrocede(otro) {
        if (otro.debo_retroceder()) {
            position = ultima_posicion
            texto_vida.mover_con_enemigo()
        }
    }

    method debo_retroceder() = vida > 0
}
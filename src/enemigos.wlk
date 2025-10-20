import personaje.pj
import textos.Vida_enemigos
import tp.configurar_juego

class Ogro {
    var property position = game.center()
    var property vida = 3
    var property ultima_posicion = game.center()
    var property danio = 1
    var property texto_vida = new Vida_enemigos(enemigo = self)
    
    method image() = "ogro_16.png"

    method derecha() {
        ultima_posicion = position
        position = position.right(1)
    }

    method izquierda() {
        ultima_posicion = position
        position = position.left(1)
    }

    method aparecer() {
        self.movete()
        game.addVisual(self)
        game.addVisual(texto_vida)
    }

    method abajo() {
        ultima_posicion = position
        position = position.down(1)
    }

    method arriba() {
        ultima_posicion = position
        position = position.up(1)
    }

    method posicion_menu() { 
        self.centrate()
        position = position.right(9)
    }

    method movete() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x, y)
    }

    method centrate() {
        position = game.center()
    }

    method chocaste_con_pj() {
        pj.fuiste_atacado(self)
        position = ultima_posicion
        texto_vida.mover_con_enemigo(position.up(1))
    }

    method mover_hacia(target) {
        if (self.position().x() < target.position().x()) {
            self.derecha()
        } else if (self.position().x() > target.position().x()) {
            self.izquierda()
        } else if (self.position().y() > target.position().y()) {
            self.abajo()
        } else if (self.position().y() < target.position().y()) {
            self.arriba()
        } 
        texto_vida.mover_con_enemigo(position.up(1))
    }

    method fuiste_atacado(enemigo, nueva_posicion) {
        vida -= enemigo.danio()
        if (vida <= 0) {
            game.removeVisual(self)
            game.removeVisual(texto_vida)
            pj.mataste_un_ogro()
        } else
            position = nueva_posicion
        
        texto_vida.mover_con_enemigo(position.up(1))
    }

}
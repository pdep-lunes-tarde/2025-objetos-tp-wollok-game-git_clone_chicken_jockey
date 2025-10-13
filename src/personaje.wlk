import textos.*
import tp.configJuego

object pj{
    var property position = game.center()
    var property vida = 5
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 0
    method image() = "manzana.png"

    method arriba(){
        position = position.up(1)
    }

    method abajo(){
        position = position.down(1)
    }

    method derecha(){
        position = position.right(1)
    }

    method izquierda(){
        position = position.left(1)
    }
    method centrate(){
        position = game.center()
    }
    method atacar_arriba(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(0)).forEach({ogro => ogro.fuiste_atacado(self, ogro.position().up(1))})
    }
    method atacar_abajo(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(1)).forEach({ogro => ogro.fuiste_atacado(self, ogro.position().down(1))})
    }
    method atacar_izquierda(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(2)).forEach({ogro => ogro.fuiste_atacado(self, ogro.position().left(1))})
    }
    method atacar_derecha(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(3)).forEach({ogro => ogro.fuiste_atacado(self, ogro.position().right(1))})
    }
    
    method sumarPuntuacion(puntosASumar){
        puntuacion += puntosASumar
    }

    method subirNivel(){
        if(puntuacion == 3){
            danio += 1
            nivel += 1
            puntuacion = 0
        }
    }

    method posiciones_alrededor(){
        return [position.up(1), position.down(1), position.left(1), position.right(1)]
    }

    

    method mataste_un_ogro(){
        self.sumarPuntuacion(1)
        self.subirNivel()
        if(nivel >= 3){
            configJuego.termino_el_juego()
            game.addVisual(you_win)
        }
    }

    method fuiste_atacado(enemigo){
        vida -= enemigo.danio()
        if(vida <= 0){
            configJuego.termino_el_juego()
            game.addVisual(game_over)
        }
    }
    
}
import wollok.game.*

object juegoIsaac{

    const ancho = 20
    const alto = 20
    method configurar() {
        game.width(ancho)
        game.height(alto)
        game.cellSize(32)
        
        keyboard.right().onPressDo {
            pj.derecha()
        }
        keyboard.d().onPressDo {
            pj.atacar_derecha()
        }
        keyboard.left().onPressDo {
            pj.izquierda()
        }
        keyboard.a().onPressDo {
            pj.atacar_izquierda()
        }
        keyboard.up().onPressDo {
            pj.arriba()
        }
        keyboard.w().onPressDo {
            pj.atacar_arriba()
        }
        keyboard.down().onPressDo {
            pj.abajo()
        }
        keyboard.s().onPressDo {
            pj.atacar_abajo()
        }
        keyboard.v().onPressDo {
            const ogro = new Ogro()
            ogro.movete()
            game.addVisual(ogro)
            game.addVisual(ogro.texto_vida())
            game.onTick(2000, "movimiento_ogro", { ogro.moverHacia(pj)})
        }
        
        game.onCollideDo(pj, { otro =>
            otro.chocaste_con_pj()
        })
        

    }
    method jugar() {
        self.configurar()
        game.start()
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        game.addVisual(vida)
    }
    method termino_el_juego(){
        game.clear()
    }

}
    
object pj{
    var property position = game.center()
    var property vida = 3
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 0
    method image() = "soldado.png"

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

        game.getObjectsIn(posiciones_a_atacar.get(0)).forEach({ogro => ogro.fuiste_atacado(self)})
    }
    method atacar_abajo(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(1)).forEach({ogro => ogro.fuiste_atacado(self)})
    }
    method atacar_izquierda(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(2)).forEach({ogro => ogro.fuiste_atacado(self)})
    }
    method atacar_derecha(){
        const posiciones_a_atacar = self.posiciones_alrededor()

        game.getObjectsIn(posiciones_a_atacar.get(3)).forEach({ogro => ogro.fuiste_atacado(self)})
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
            juegoIsaac.termino_el_juego()
            game.addVisual(you_win)
        }
    }

    method fuiste_atacado(enemigo){
        vida -= enemigo.danio()
        if(vida <= 0){
            juegoIsaac.termino_el_juego()
            game.addVisual(game_over)
        }
    }
    
}

class Ogro{
    var property position = game.center()
    var property vida = 2
    var property ultimaPosicion = game.center()
    var property danio = 1
    var property texto_vida = new Vida_enemigos(enemigo = self) 
    method image() = "Orco.png"

    method derecha(){
        ultimaPosicion = position
        position = position.right(1)
    }

    method izquierda(n){
        ultimaPosicion = position
        position = position.left(n)
    }

    method abajo(){
        ultimaPosicion = position
        position = position.down(1)
    }

    method arriba(){
        ultimaPosicion = position
        position = position.up(1)
    }

    method movete() {
    const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0)
    position = game.at(x,y)
    }

    method centrate(){
        position = game.center()
    }

    method chocaste_con_pj(){
        pj.fuiste_atacado(self)
        position = ultimaPosicion
        texto_vida.mover_con_enemigo(position.up(1))

    }

    method moverHacia(target) {
        if (self.position().x() < target.position().x()){
            self.derecha()
        } else if (self.position().x() > target.position().x()){
            self.izquierda(1)
        } else if (self.position().y() > target.position().y()){
            self.abajo()
        } else if (self.position().y() < target.position().y()){
            self.arriba()
        } 
        texto_vida.mover_con_enemigo(position.up(1))
    }

    method fuiste_atacado(enemigo){
        vida -= enemigo.danio()
        if(vida <= 0){
            game.removeVisual(self)
            game.removeVisual(texto_vida)
            pj.mataste_un_ogro()
        } else position = ultimaPosicion
                texto_vida.mover_con_enemigo(position.up(1))

    }
}

object puntuacion{
    method position() = new Position(x=1, y=19)

    method text() = "Puntuacion: " + pj.puntuacion()

    method textColor() = paleta.negro()

}

object paleta{
    const property negro = "000000"
}

object nivel {
    method position() = new Position(x=1, y=18)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = paleta.negro()

}

object vida{
    method position() = new Position(x=18, y=19)

    method text() = "Vida: " + pj.vida()

    method textColor() = paleta.negro()
}

object game_over {
    method position() = game.center()

    method text() = "GAME OVER"

    method textColor() = paleta.negro() 
}

object you_win {
    method position() = game.center()

    method text() = "YOU WIN"

    method textColor() = paleta.negro() 
}

class Vida_enemigos{
    const property enemigo
    var property position = enemigo.position().up(1)

    method text() = "Vida: " + enemigo.vida()

    method textColor() = paleta.negro() 

    method mover_con_enemigo(nueva_posicion){
        position = nueva_posicion
        if(enemigo.vida() <= 0){
                game.removeVisual(self)
        }
    }
}

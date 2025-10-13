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
            pj.derecha()
        }
        keyboard.left().onPressDo {
            pj.izquierda()
        }
        keyboard.a().onPressDo {
            pj.izquierda()
        }
        keyboard.up().onPressDo {
            pj.arriba()
        }
        keyboard.w().onPressDo {
            pj.arriba()
        }
        keyboard.down().onPressDo {
            pj.abajo()
        }
        keyboard.s().onPressDo {
            pj.abajo()
        }
        keyboard.v().onPressDo {
            const ogro = new Ogro()
            ogro.movete()
            game.addVisual(ogro)
            keyboard.any().onPressDo {
                ogro.moverHacia(pj)
            }
    
        }
        game.onCollideDo(pj, { otro =>
            otro.chocasteConPj(pj)
        })
        

    }
    method jugar() {
        self.configurar()
        game.start()
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        
    }

}
    
object pj{
    var property position = game.center()
    var property vida = 3
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 1
    var property knockback = 3
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
    
}

class Ogro{
    var property position = game.center()
    var property vida = 2
    var property ultimaPosicion = game.center()
    method image() = "ogro.png"

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

    method chocasteConPj(pj){
        if(vida <= 0){
            game.removeVisual(self)
            pj.sumarPuntuacion(1)
            pj.subirNivel()
        } else {
            vida -= pj.danio()
            pj.knockback(3)
        }

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
    }

    method knockback(distancia){
        const x = position.x() - ultimaPosicion.x()
        const y = position.y() - ultimaPosicion.y()
        if (x > 0) {
            position = position.left(distancia)
        } else if (x < 0) {
            position = position.right(distancia)
        } else if (y > 0) {
            position = position.down(distancia)
        } else if (y < 0) {
            position = position.up(distancia)
        }
    }

}

object puntuacion{
    method position() = new Position(x=1, y=19)

    method text() = "Puntuacion: " + pj.puntuacion()

    method textColor() = paleta.negro()

    method chocasteConPj(){

    }
}

object paleta{
    const property negro = "000000"
}

object nivel {
    method position() = new Position(x=0.5, y=18)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = paleta.negro()

    method chocasteConPj(){

    }
}


import personaje.pj
import textos.Vida_enemigos
import tp.configJuego

class Ogro{
    var property position = game.center()
    var property vida = 3
    var property ultimaPosicion = game.center()
    var property danio = 1
    var property texto_vida = new Vida_enemigos(enemigo = self) 
    method image() = "ogro_16.png"

    method derecha(){
        ultimaPosicion = position
        position = position.right(1)
    }

    method izquierda(n){
        ultimaPosicion = position
        position = position.left(n)
    }

    method aparecer(){
        self.movete()
        game.addVisual(self)
        game.addVisual(texto_vida)
    }

    method abajo(){
        ultimaPosicion = position
        position = position.down(1)
    }

    method arriba(){
        ultimaPosicion = position
        position = position.up(1)
    }


    method posicion_menu(){ 
        self.centrate()
        position = position.right(9)
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
        if(!pj.invulnerable()){
        pj.fuiste_atacado(self)
        }
        position = ultimaPosicion
        texto_vida.mover_con_enemigo(position.up(1))

    }

    method moverHacia(target) {
        const random = 0.randomUpTo(1)
        
        if (random > 0.5) {
        self.mover_en_x(target)
        if (self.position().x() == target.position().x()) {
            self.mover_en_y(target)
        }
    } else { 
        self.mover_en_y(target)
        if (self.position().y() == target.position().y()) {
            self.mover_en_x(target)
        }
    }

        texto_vida.mover_con_enemigo(position.up(1))
    }

    method mover_en_x(target){
        if (self.position().x() < target.position().x()){
            self.derecha()
        } else if (self.position().x() > target.position().x()){
            self.izquierda(1)
        } 
    }

    method mover_en_y(target){
        if (self.position().y() > target.position().y()){
            self.abajo()
        }else if (self.position().y() < target.position().y()){
            self.arriba()
        } 
    }

    method fuiste_atacado(enemigo, nueva_posicion){
        vida -= enemigo.danio()
        if(vida <= 0){
            game.removeVisual(self)
            game.removeVisual(texto_vida)
            pj.mataste_un_ogro()
        } else position = nueva_posicion
                texto_vida.mover_con_enemigo(position.up(1))

    }
        
}
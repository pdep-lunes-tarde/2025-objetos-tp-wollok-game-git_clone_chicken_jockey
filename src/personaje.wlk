import textos.*
import tp.configJuego

object pj{
    var property position = game.center()
    var property vida = 3
    var property puntuacion = 0
    var property danio = 1
    var property nivel = 0
    var property enemigos_asesinados = 0 
    var velocidad = 1
    var property invulnerable = false
    method image() = "manzana_16.png"

    method arriba(){
        if(position.y() <= configJuego.alto() - 2){ // el numero es para que se vea, varia segun el tamano de las celdas
            position = position.up(velocidad)
        }
        
    }

    method abajo(){
        if(position.y() >= 0){
        position = position.down(velocidad)
        }
    }

    method derecha(){
        if(position.x() <= configJuego.ancho() - 2){ // el numero es para que se vea, varia segun el tamano de las celdas
        position = position.right(velocidad)
        }
    }

    method izquierda(){
        if(position.x() >= 0){
        position = position.left(velocidad)
        }
    }
    method centrate(){
        position = game.center()
    }

    method posicion_menu(){ 
        self.centrate()
        position = position.left(9)
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
        if(puntuacion >= 3){
            danio += 1
            nivel += 1
            puntuacion = 0
        } 
    }

   /* method subir_nivel(){
        game.addVisual(imagen_subida_de_nivel)
        game.addVisual(texto_subida_de_nivel)
        nivel += 1
            keyboard.s().onPressDo{
                velocidad += 1
                game.removeVisual(imagen_subida_de_nivel)
                game.removeVisual(texto_subida_de_nivel)
            }
            keyboard.d().onPressDo{
                danio += 1
                game.removeVisual(imagen_subida_de_nivel)
                game.removeVisual(texto_subida_de_nivel)
            }
            keyboard.v().onPressDo{
                self.recibirVida()
                game.removeVisual(imagen_subida_de_nivel)
                game.removeVisual(texto_subida_de_nivel)
            }
        
    }
    */
    method posiciones_alrededor(){
        return [position.up(1), position.down(1), position.left(1), position.right(1)]
    }

    

    method mataste_un_ogro(){
        self.sumarPuntuacion(1)
        if(nivel >= 3){
            configJuego.termino_el_juego()
            game.addVisual(you_win)
        }
        enemigos_asesinados += 1
    }

    method fuiste_atacado(enemigo){
        vida -= enemigo.danio()
        barra_de_vida.restar_vida()
        if(vida <= 0){
            configJuego.termino_el_juego()
        }
    }
    
    method recibirVida(){
        if(vida < 3){
            vida += 1
            barra_de_vida.sumar_vida()
        }
    }

    method reiniciate(){
        vida = 3
        puntuacion = 0
        danio = 1
        nivel = 0
        self.centrate()
    }
}

object barra_de_vida{
    var property corazones = [new Imagen_corazon (position = new Position(x = configJuego.ancho() - 2, y = configJuego.alto() - 1)), new Imagen_corazon (position = new Position(x = configJuego.ancho() - 3, y = configJuego.alto() - 1)), new Imagen_corazon (position = new Position(x = configJuego.ancho() - 4, y = configJuego.alto() - 1))]
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
        corazones = [new Imagen_corazon (position = new Position(x = configJuego.ancho() - 2, y = configJuego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configJuego.ancho() - 3, y = configJuego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configJuego.ancho() - 4, y = configJuego.alto() - 1))]
    }
}
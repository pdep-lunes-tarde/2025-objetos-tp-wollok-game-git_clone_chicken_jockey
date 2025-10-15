import wollok.game.*
import personaje.pj
import textos.*
import enemigos.*
import objetos.*

object configJuego{

    const property ancho = 30
    const property alto = 30
    var clock_enemigos = 0
    method configurar() {
        game.width(ancho)
        game.height(alto)
        game.cellSize(16)
        
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
        keyboard.any().onPressDo {
            if (clock_enemigos == 2){
            const ogro = new Ogro()
            ogro.aparecer()
            keyboard.any().onPressDo{ ogro.moverHacia(pj)}
            const moneda = new Moneda()
            moneda.aparecer()
            clock_enemigos = 0
            }clock_enemigos += 1

        }

        game.onTick(1000, "aumentar_tiempo", { tiempo.aumentarTiempo() })
        
        game.onCollideDo(pj, { otro =>
            otro.chocaste_con_pj()
        })
        

    }
    method jugar() {
        self.configurar()
        game.start()
        self.agregar_visuales_iniciales()
    }
    method termino_el_juego(){
        game.clear()
    }

    method agregar_visuales_iniciales(){
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        game.addVisual(vida)
        game.addVisual(tiempo)
    }

}



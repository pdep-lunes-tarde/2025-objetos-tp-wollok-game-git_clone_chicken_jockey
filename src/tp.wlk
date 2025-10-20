import wollok.game.*
import personaje.*
import textos.*
import enemigos.*
import objetos.*

object configurar_juego {
    var property ancho = 30
    var property alto = 30
    var clock_enemigos = 0
    var facilidad = 6

    method configurar() {
        game.width(ancho)
        game.height(alto)
        game.cellSize(16)
    }

    method jugar() {
        self.configurar()
        game.start()
        self.mostrar_menu()
    }

    method perdi() {
        game.clear()
        game.addVisual(game_over)
        self.reiniciar_juego() 
    }
    method gane() {
        game.clear()
            game.addVisual(you_win)
            self.reiniciar_juego() 
            
    }

    method reiniciar_juego() {
        game.addVisual(texto_estadisticas)
            keyboard.r().onPressDo {
                game.clear()
                pj.reiniciate()
                tiempo.reiniciate()
                clock_enemigos = 0
                self.mostrar_menu()
            }

        
        

    }

    method agregar_visuales_iniciales() {
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        game.addVisual(tiempo)
        game.addVisual(vida)
    }

    method mostrar_menu() {
        const ogro = new Ogro()

        game.addVisual(texto_menu)
        pj.posicion_menu()
        game.addVisual(pj)

        ogro.posicion_menu()
        game.addVisual(ogro)

        keyboard.enter().onPressDo {
            game.clear()
            self.empezar_juego()
        }

        keyboard.c().onPressDo {
            game.clear()
            self.mostrar_controles()
        }

        keyboard.f().onPressDo {
            game.clear()
            self.mostrar_facilidad()
        }
    }

    method mostrar_controles() {
        game.addVisual(controles)
        game.addVisual(volver_atras)

        keyboard.b().onPressDo {
            game.clear()
            self.mostrar_menu()
        }
    }
    method mostrar_facilidad() {
        game.addVisual(texto_facilidad)
        game.addVisual(marcador_facilidad)
        game.addVisual(volver_atras)

        keyboard.f().onPressDo{
            facilidad = 6
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.m().onPressDo{
            facilidad = 4
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.d().onPressDo{
            facilidad = 2
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.b().onPressDo {
            game.clear()
            self.mostrar_menu()
        }
    }

    method empezar_juego() {
        pj.centrate()
        self.agregar_visuales_iniciales()

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

            if (clock_enemigos == facilidad) {
                const ogro = new Ogro()
                const moneda = new Moneda()

                ogro.aparecer()

                keyboard.any().onPressDo{ ogro.mover_hacia(pj) }

                self.agregar_objeto_aleatorio()

                clock_enemigos = 0
                game.onCollideDo(ogro, {otro => ogro.retrocede(otro)} )
            }
            
            clock_enemigos += 1
        }
        


        game.onTick(1000, "aumentar_tiempo", { tiempo.aumentarTiempo() })
        
        game.onCollideDo(pj, { otro =>
            otro.chocaste_con_pj()
        })
        
        
    }

    method agregar_objeto_aleatorio() {
        const probabilidad_corazon = 0.3

        const numero_aleatorio = 0.randomUpTo(1)

        if (numero_aleatorio < probabilidad_corazon) {
            const corazon = new Corazon()
            corazon.aparecer()
        } else  {
            const moneda = new Moneda()
            moneda.aparecer()
        }
    }
}
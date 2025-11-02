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
    var lentitud_enemigos = 0
    var cantidad_enemigos = 0
    const cantidad_enemigos_max = 10

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
                barra_de_vida.reiniciate()
                tiempo.reiniciate()
                clock_enemigos = 0
                self.mostrar_menu()
                lentitud_enemigos = 0
                cantidad_enemigos = 0
            }
    }

    method agregar_visuales_iniciales() {
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        game.addVisual(tiempo)
        barra_de_vida.corazones_vacios().forEach({corazon_vacio => game.addVisual(corazon_vacio)})
        barra_de_vida.corazones().forEach({corazon => game.addVisual(corazon)})
    }

    method mostrar_menu() {
        const ogro = new Ogro(vida = 3)

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
        const moneda = new Moneda()
        moneda.aparecer()
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

            if (clock_enemigos >= facilidad - pj.nivel() && cantidad_enemigos < cantidad_enemigos_max) {
                const ogro = new Ogro(vida = 3 + pj.nivel(), lentitud = lentitud_enemigos)

                ogro.aparecer()
                
                keyboard.any().onPressDo{ ogro.mover_hacia(pj) }

                clock_enemigos = 0
                game.onCollideDo(ogro, {otro => ogro.retrocede(otro)} )
                cantidad_enemigos += 1
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
            const pocion_vida = new Pocion_vida()
            pocion_vida.aparecer()
        } else  {
            const moneda = new Moneda()
            moneda.aparecer()
        }
    }
    method sumar_lentitud_enemigos() {
        lentitud_enemigos += 1
    }

    method reducir_cantidad_enemigos() {
        if (cantidad_enemigos > 0) {
            cantidad_enemigos -= 1
        }
    }

    method mostrar_menu_subida_nivel(objetos_aleatorios) {
        game.clear()
        cantidad_enemigos = 0
        objetos_aleatorios.forEach({objeto => game.addVisual(objeto)})
        game.addVisual(texto_subida_de_nivel)
        game.addVisual(text_seleccion_objetos)
        keyboard.num0().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(0))
        }
        keyboard.num1().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(1))
        }
        keyboard.num2().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(2))
        }
        
    }
}
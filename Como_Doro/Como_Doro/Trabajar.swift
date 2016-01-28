//
//  Trabajar.swift
//  Como_Doro
//
//  Created by Egoitz and Vicente on 28/1/16.
//  Copyright © 2016 Egibide. All rights reserved.
//

import UIKit

class Trabajar: UIViewController {
    
    //Variables que definen la duración de los ciclos de los procesos en segundos
    //Duración de un ciclo de trabajo del Pomodoro
    var cicloTrabajo : Double = 1500
    //Duración de un ciclo de descanso corto del Pomodoro
    var cicloDescansoCorto : Double = 300
    //Duración de un ciclo de descanso largo del Pomodoro
    var cicloDescansoLargo : Double = 1200
    
    //Variable que guarda el incremento por cada ciclo en segundos del reloj
    var intervaloTiempo : Double = 1
    
    
    // Doración de un ciclo de trabajo para el contador Laboral del Pomodoro
    var cicloTrabajoLaboral : Double = 14400
    
    // Durarión de un ciclo de descanso para el contador Laboral del Pomodoro
    var cicloDescansoLaboral : Double = 1200
    
    //Tiempo estimado jornada laboral
    var jornadaEstimada : Int16 = 8
    
    //Variable del temporizador del proceso de trabajo en curso
    var _tempTrabajo : NSTimer = NSTimer()
    //Variable del temporizador
    var _tempContador : NSTimer = NSTimer()
    //Variable del temporizador del proceso en curso
    var _tempProceso : NSTimer = NSTimer()
    
    //Variable del temporizar del proceso de trabajo laboral en curso
    var _tempTrabajoLaboral : NSTimer = NSTimer()
    
    //Fecha y hora en la que se crea la clase
    var _creacionClase : NSDate = NSDate()
    
    //Cantidad de trabajos completados desde que se crea la clase
    var trabajosCompletados : Int16 = 0
    //Cantidad de descansos cortos completados desde que se inicia la clase
    var descansosCortosCompletados : Int16 = 0
    //Cantidad de descansos largos completados desde que se inicia la clase
    var descansosLargosCompletados : Int16 = 0
    //Segundos transcurridos desde que el inicio del ultimo contador
    var segundosTranscurridos : Double = 0
    // Variable que guarda el ciclo activo
    var estadoActual : Int16 = 0
    // Variable que al adquirir el valor TRUE indica que ha concluido un ciclo
    var alarma : Bool = false
    
    //Cantidad de descansos laborales realizados desde el inicio de la clase
    var descansosLaboralesCompletados : Int16 = 0
    //Cantidad de trabajos laborales completados
    var trabajosLaboralesCompletados : Int16 = 0
    // Estado actual del contador laboral
    var estadoLaboralActual : Int16 = 0
    // Variable de finalización de ciclo
    var alarmaLaboral : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tomato.jpg")!)
        //Iniciamos los relojes al iniciar la clase.
        iniciar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Método que inicia el Pomodoro
    func iniciar(){
        //Iniciamos el reloj que mide el tiempo que se muestra en pantalla
        _tempContador = NSTimer.scheduledTimerWithTimeInterval(intervaloTiempo, target: self, selector: Selector("contadorTTranscurrido"), userInfo: nil, repeats: true)
        //Iniciamos los ciclos de los contadores de trabajo
        siguienteCiclo()
    }
    
    // Método que carga y ejecuta el tipo de ciclo del Pomodoro
    func siguienteCiclo(){
        
        //En esta estructura controlamos los ciclos del Pomodoro
        if (alarma == true && alarmaLaboral == false) || trabajosCompletados == 0{
            if (descansosCortosCompletados + descansosLargosCompletados == trabajosCompletados) {
                trabajosCompletados++
                estadoActual=1
                _tempTrabajo = NSTimer.scheduledTimerWithTimeInterval(cicloTrabajo, target: self, selector: Selector("finProceso"), userInfo: nil, repeats: false)
                LabelEstado.text = "Trabajando"
                alarma = false
                segundosTranscurridos=0
            }else{
                if ((descansosCortosCompletados / 3) == descansosLargosCompletados+1) {
                    descansosLargosCompletados++
                    estadoActual = 3
                    _tempProceso = NSTimer.scheduledTimerWithTimeInterval(cicloDescansoLargo, target: self, selector: Selector("finProceso"), userInfo: nil, repeats: false)
                }else{
                    descansosCortosCompletados++
                    estadoActual = 2
                    _tempProceso = NSTimer.scheduledTimerWithTimeInterval(cicloDescansoCorto, target: self, selector: Selector("finProceso"), userInfo: nil, repeats: false)
                }
                LabelEstado.text = "Descanso"
                alarma = false
                segundosTranscurridos=0
            }
        }
        //En esta estructura controlamos los ciclos laborales
        if alarmaLaboral == true || trabajosLaboralesCompletados == 0 {
            
            if  (descansosLaboralesCompletados == trabajosLaboralesCompletados) {
                trabajosLaboralesCompletados++
                estadoLaboralActual=1
                _tempTrabajoLaboral = NSTimer.scheduledTimerWithTimeInterval(cicloTrabajoLaboral, target: self, selector: Selector("finProcesoLaboral"), userInfo: nil, repeats: false)
                LabelEstado.text = "Trabajando"
                alarmaLaboral = false
            }else{
                if (descansosLaboralesCompletados == (trabajosLaboralesCompletados - 1)) {
                    descansosLaboralesCompletados++
                    estadoLaboralActual = 2
                    _tempTrabajoLaboral = NSTimer.scheduledTimerWithTimeInterval(cicloDescansoLaboral, target: self, selector: Selector("finProcesoLaboral"), userInfo: nil, repeats: false)
                    LabelEstado.text = "PISCOLABIS!!"
                }else{
                    trabajosLaboralesCompletados++
                    estadoLaboralActual = 1
                    _tempTrabajoLaboral = NSTimer.scheduledTimerWithTimeInterval((cicloTrabajoLaboral-cicloDescansoLaboral), target: self, selector: Selector("finProcesoLaboral"), userInfo: nil, repeats: false)
                    LabelEstado.text = "Trabajando"
                }
                alarmaLaboral = false
            }
        }
    }
    
    // Método que muestra en el StoryBoard el tiempo transcurrido total y del ciclo activo
    func contadorTTranscurrido(){
        ContadorTotal.text = tTotal()
        if (estadoActual>0) && (estadoLaboralActual>0) {
            ContadorActivo.text = tiempoCicloTranscurrido()
        }else{
            BotonDetenerOutlet.setTitle("Reanudar",forState: UIControlState.Normal)
            BotonDetenerOutlet.backgroundColor = UIColor.redColor()
        }
    }
    
    // Método que calcula el tiempo transcurrido desde el inicio del Pomodoro
    func tTotal()->String{
        let fechaActual = NSDate()
        segundosTranscurridos++
        return convertirSegundos(fechaActual.timeIntervalSinceDate(_creacionClase))
    }
    
    // Método que devuelve el tiempo del ciclo transcurrido como un String
    func tiempoCicloTranscurrido()->String{
        return convertirSegundos(segundosTranscurridos)
    }
    
    // Método para convertir el tiempo transcurrido en segundos a horas, minutos y segundos
    func convertirSegundos(segundos: Double)->String{
        if (segundos < 3600){
            return String(format: "%02d:%02d", (Int(segundos / 60) % 60), Int(segundos % 60))
        }else{
            return String(format: "%02d:%02d:%02d", Int(segundos/3600), Int((segundos / 60) % 60), Int(segundos % 60))
        }
    }
    
    // Método que finaliza el ciclo de un Pomodoro
    func finProceso(){
        _tempProceso.invalidate()
        estadoActual = 0
        alarma = true
    }
    
    //Método que finaliza el ciclo Laboral
    func finProcesoLaboral(){
        _tempTrabajoLaboral.invalidate()
        estadoLaboralActual = 0
        alarmaLaboral = true
    }
    //Outlets para mostrar información en pantalla
    @IBOutlet weak var ContadorActivo: UILabel!
    @IBOutlet weak var ContadorTotal: UILabel!
    @IBOutlet weak var BotonDetenerOutlet: UIButton!
    @IBOutlet weak var LabelEstado: UILabel!
    //Control de la función del botón en pantalla, para cambiar de ciclo o para salir del programa
    @IBAction func botonDetener(sender: UIButton) {
        //En caso de que un ciclo finalize el botón muestra la opción de reiniciar
        if alarma == true || alarmaLaboral == true {
            siguienteCiclo()
            BotonDetenerOutlet.setTitle("Detener",forState: UIControlState.Normal)
            BotonDetenerOutlet.backgroundColor = UIColor.whiteColor()
            //Si ningún ciclo ha concluido el botón efectuará la salida de la ventana a la pantalla de selección
        } else {
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
}

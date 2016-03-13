//
//  ViewController.swift
//  PeticionAServidorOpenlibrary
//
//  Created by mac on 03/12/16.
//  Copyright © 2016 Juan Sebastian Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var capturaISBN: UITextField! // texto para cambiar ISBN
    @IBOutlet weak var devuelveLibro: UITextView! // descripcion de libro
    
    var ISBN = 0
    
    func sincrono(){ //  -----> FUNCION SINCRONO <-----
        //let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7" // direccion del servidor
        
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"

        urls += capturaISBN.text! // concatena la URL con el ISBN que se ingrese
        
        let url = NSURL (string: urls) //convierte a URL la direccion del servidor
        let datos : NSData? = NSData(contentsOfURL: url!) // hace peticion al servidor
       
        if datos  != nil {

            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding) //codifica a UTF8
            //print(texto!)
            
            if texto == "{}"{
                devuelveLibro.text = "ISBN No Encontrado"
            }else{
                var tempTexto = texto as! String // convierte el NSString en string
                devuelveLibro.text = tempTexto //evia a uitextview el texto
            }
            
            

        }else{
            devuelveLibro.text = "Verifique su conexion a Internet"
            
        }
        
    }
    
    
    func asincrono (){ // -----> FUNCION ASINCRONO <-----
      
        //let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7" // direccion del servidor
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls += capturaISBN.text!
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession() // sesion compartida permite hacer llamada asincrona, libera al cliente para que no espere que el servidor procese la peticion
        let bloque = { (datos: NSData?, resp : NSURLResponse?, error : NSError?) -> Void in let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print (texto!)
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        print("antes o despues")
        
        
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Boton Limpiar
    @IBAction func LimpiarISBN(sender: AnyObject) {
        capturaISBN.text = ""
        devuelveLibro.text = ""
    }
    
    // Boton Buscar
    @IBAction func BuscarISBN() {
        sincrono()

        
       // devuelveLibro.text = capturaISBN.text
  
        
    }
    
    
}


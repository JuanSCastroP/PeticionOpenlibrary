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
    @IBOutlet weak var devuelveTitulo: UITextView!
    @IBOutlet weak var devuelveAutor: UITextView!
    @IBOutlet weak var devuelvePortada: UIImageView!
    @IBOutlet weak var labPortada: UILabel!
    
    var ISBN = 0
    
    func sincrono(){ //  -----> FUNCION SINCRONO <----- otro ISBN 9780071599894
        //let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7" // direccion del servidor
        
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"

        urls += capturaISBN.text! // concatena la URL con el ISBN que se ingrese
        
        let url = NSURL (string: urls) //convierte a URL la direccion del servidor
        let datos : NSData? = NSData(contentsOfURL: url!) // hace peticion al servidor
       
        if datos  != nil {

            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding) //codifica a UTF8
            //print(texto!)
            
            if texto == "{}"{
                devuelveTitulo.text = "ISBN No Encontrado"
                showErrorAlertMessage(devuelveTitulo.text)
                
            }else{
                //var tempTexto = texto as! String // convierte el NSString en string
                //devuelveLibro.text = tempTexto //evia a uitextview el texto
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let codISBN = "ISBN:" + self.capturaISBN.text!
                    let dico1 = json as! NSDictionary
                    let dico2 = dico1[codISBN] as! NSDictionary
                    let title = dico2["title"] as! NSString as String
                    
                    let authors = dico2["authors"] as? [[String: AnyObject]]
                    
                    var autores: String = ""
                    for autor  in authors!
                    {
                        if let name = autor["name"] as? String
                        {
                            // Do stuff with data
                            if ( autores != "" )
                            {
                                autores = autores + ","
                            }
                            autores = autores + (name)
                        }
                    }
                    
                    if let portada1 = dico2["cover"]
                    {
                        let portadas = portada1 as! NSDictionary
                        let portada = portadas["medium"] as! NSString as String
                        if let checkedUrl = NSURL(string: portada) {
                            self.devuelvePortada.contentMode = .ScaleAspectFit
                            //self.downloadImage(checkedUrl)
                            self.labPortada.text = "No hay portada"
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        //self.resultsTextView.text = (texto as! String)
                        self.devuelveTitulo.text = title
                        self.devuelveAutor.text = autores
                        self.labPortada.text = "No hay portada"
                    })
                    
                }//llave do
                catch _{
                }
                
                
                
            }
            
            

        }else{
            devuelveTitulo.text = "Verifique su conexion a Internet"
            showErrorAlertMessage(devuelveTitulo.text)
        }
    }
    
    private func showErrorAlertMessage(mensaje: String) {
        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        //clearFields()
    }
    
    
    
    

   func asincrono (){ // -----> FUNCION ASINCRONO <-----
      
/*        //let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7" // direccion del servidor
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls += capturaISBN.text!
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession() // sesion compartida permite hacer llamada asincrona, libera al cliente para que no espere que el servidor procese la peticion
        let bloque = { (datos: NSData?, resp : NSURLResponse?, error : NSError?) -> Void in let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print (texto!)
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        print("antes o despues")*/
        
        func buscarISBN( isbn: NSString){ // funcion para buscar ISBN 9780071599894 y/o 978-84-376-0494-7
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + (isbn as String)
            let url = NSURL(string: urls)
            let sesion = NSURLSession.sharedSession()
            let bloque = { (datos: NSData?, resp : NSURLResponse?, error: NSError?) -> Void in
            
                if((error) != nil)
                {
                    let alertController = UIAlertController(title: "Información del Libro", message:
                        error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                else
                {
                do
                    {
                        let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                        let codISBN = "ISBN:" + self.capturaISBN.text!
                        let dico1 = json as! NSDictionary
                        let dico2 = dico1[codISBN] as! NSDictionary
                        let title = dico2["title"] as! NSString as String
                        let autor = dico2["Autor"] as? [[String: AnyObject]]
                    
                        var autores: String = ""
                        for autor  in autor!
                        {
                            if let name = autor["name"] as? String
                            {
                                // Do stuff with data
                                if ( autores != "" )
                                {
                                    autores = autores + ","
                                }
                                autores = autores + (name)
                            }
                        }
                    
                        if let portada1 = dico2["cover"]
                        {
                            let portadas = portada1 as! NSDictionary
                            let portada = portadas["medio"] as! NSString as String
                            if let checkedUrl = NSURL(string: portada) {
                                //self.imageView.contentMode = .ScaleAspectFit
                                //self.downloadImage(checkedUrl)

                            }
                        }
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                            //self.resultsTextView.text = (texto as! String)
                            self.devuelveTitulo.text = title
                            self.devuelveAutor.text = autores
                            self.labPortada.text = "No hay portada"
                        })
                    
                    }//llave do
                catch _{
                }
                } // lave else
            } //Llave buscar ISBN
        } // llaves de la funcion asincrona
        
    } // llave ViewController
    
 
    
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
        devuelveTitulo.text = ""
        devuelveAutor.text = ""
    }
    
    // Boton Buscar
    @IBAction func BuscarISBN() {
        sincrono()

        
       // devuelveLibro.text = capturaISBN.text
  
        
    }
    
    
}


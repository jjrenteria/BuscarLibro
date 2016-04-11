//
//  ViewController.swift
//  BuscarLibro
//
//  Created by Juan Jose Renteria on 10/04/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var textoResultado: UITextView!
    
    @IBOutlet weak var textoIsbn: UITextField!
    
    
     // limpia el campo para buscar libro
    @IBAction func limpiarTexto(sender: UIButton) {
        textoIsbn.text = nil
        textoResultado.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textoIsbn.delegate = self
        textoIsbn.text = nil
        textoResultado.text = nil
    }

    //Efectua la busqueda por ISBN
    func buscarLibro(isbn: String?) {
 //       NSLog("buscarLibro")
        if isbn != nil {
            let isbnUrl = "https://wwwopenlibrary.org/api/books?jscmd=data&format=json&bibkeys=\(isbn!)"    //ISBN:978-84-376-0494-7
            let url = NSURL(string: isbnUrl)
            let session = NSURLSession.sharedSession()
            let bloque = { (datos: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if datos != nil {
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        let texto = String(data: datos!, encoding: NSUTF8StringEncoding)
                        self.textoResultado.text = texto
                    })

                }
                // Mostrar alerta si hubo error
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Error al consultar libro", message: error.debugDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                    
                }
                
            }
            let dt = session.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
            
        }
        
    }

    // MARK: UITextViewDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        buscarLibro(textField.text)
    }
    
}


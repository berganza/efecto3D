//
//  GameViewController.h
//  efecto3D
//

//  Copyright (c) 2014 Berganza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface GameViewController : UIViewController {

    // Escena
    SCNScene * escena;
    
    // Referencias de nodos para manipular posterioemente
    SCNNode * manejoCamara;
    SCNNode * orientacionCamara;
    SCNNode * nodoCamera;
    SCNNode * puntoLuzNodoPrincipal;
    SCNNode * puntoLuzNodo;
    SCNNode * nodoSuelo;
    SCNNode * nodoLogo;
    
    SCNNode * nodoGrupo;
}

@end

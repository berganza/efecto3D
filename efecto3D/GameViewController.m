//
//  GameViewController.m
//  efecto3D
//
//  Created by Berganza on 20/09/14.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

#import "GameViewController.h"

@import SceneKit;
@import SpriteKit;

#define TXOROTXORI_IMAGEN 30

@implementation GameViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self configuracionGeneral];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self efectoFadeIn];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void) configuracionGeneral {
    
    SCNView * vistaEscena = (SCNView *)self.view;
    
    vistaEscena.backgroundColor = [SKColor blackColor];
    
    // setup la escena
    [self configuracionEscena];
    
    // Mostrar la escena
    vistaEscena.scene = escena;
    
    // Ajustar la física
    vistaEscena.scene.physicsWorld.speed = 2.0;
    vistaEscena.jitteringEnabled = YES;
    
    // Punto de vista inicial
    vistaEscena.pointOfView = nodoCamera;
}

- (void) configuracionEscena {
    
    escena = [SCNScene scene];
    
    // Configuaración del ambiente
    [self configuracionCamara];
    [self configuracionPuntoLuz];
    [self configuracionSuelo];
    
    // Configuración de la iluminación para la introducción (iluminación oscura)
    puntoLuzNodo.light.color = [SKColor blackColor];
    puntoLuzNodo.position = SCNVector3Make(50, 90, -50);
    puntoLuzNodo.eulerAngles = SCNVector3Make(-M_PI_2*0.75, M_PI_4*0.5, 0);
    
    [self setupLogo];
}

- (void) configuracionCamara {
    
    // |_   manejoCamara
    //   |_   orientacionCamara
    //     |_   nodoCamara
    
    // Crear la cámara principal
    nodoCamera = [SCNNode node];
    nodoCamera.position = SCNVector3Make(0, 0, 120);
    
        // Crear un nodo para manipular la orientación de la cámara
        manejoCamara = [SCNNode node];
        manejoCamara.position = SCNVector3Make(0, 60, 0);
        orientacionCamara = [SCNNode node];
    
            // Nodo de cámara
            nodoCamera.camera = [SCNCamera camera];
            nodoCamera.camera.zFar = 800;
            nodoCamera.camera.yFov = 55;
    
    [escena.rootNode addChildNode:manejoCamara];
    [manejoCamara addChildNode:orientacionCamara];
    [orientacionCamara addChildNode:nodoCamera];
}

// añadir una luz a la escena
- (void) configuracionPuntoLuz {
    
    puntoLuzNodoPrincipal = [SCNNode node];
    puntoLuzNodoPrincipal.position = SCNVector3Make(0, 90, 20);
    
    puntoLuzNodo = [SCNNode node];
    puntoLuzNodo.rotation = SCNVector4Make(1,0,0,-M_PI_4);
    
    puntoLuzNodo.light = [SCNLight light];
    puntoLuzNodo.light.type = SCNLightTypeSpot;
    puntoLuzNodo.light.color = [SKColor colorWithWhite:1 alpha:1];
    puntoLuzNodo.light.castsShadow = YES;
    puntoLuzNodo.light.shadowColor = [SKColor colorWithWhite:0 alpha:0.5];
    puntoLuzNodo.light.zNear = 30;
    puntoLuzNodo.light.zFar = 800;
    puntoLuzNodo.light.shadowRadius = 1.0;
    puntoLuzNodo.light.spotInnerAngle = 15;
    puntoLuzNodo.light.spotOuterAngle = 70;
    
    [nodoCamera addChildNode:puntoLuzNodoPrincipal];
    [puntoLuzNodoPrincipal addChildNode:puntoLuzNodo];
}

// Configuración de la baldosa
- (void) configuracionSuelo {
    
    SCNFloor * baldosa = [SCNFloor floor];
    baldosa.reflectionFalloffEnd = 0;
    baldosa.reflectivity = 0;
    
    nodoSuelo = [SCNNode node];
    nodoSuelo.geometry = baldosa;
    nodoSuelo.geometry.firstMaterial.diffuse.contents = @"baldosa.png";
    nodoSuelo.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
    nodoSuelo.geometry.firstMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    nodoSuelo.geometry.firstMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    nodoSuelo.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    
    nodoSuelo.physicsBody = [SCNPhysicsBody staticBody];
    nodoSuelo.physicsBody.restitution = 1.0;
    
    [escena.rootNode addChildNode:nodoSuelo];
}

- (void) setupLogo {
    
    // Poner todos los textos en grupo
    nodoGrupo = [SCNNode node];
    
    nodoLogo = [SCNNode nodeWithGeometry:[SCNPlane planeWithWidth:TXOROTXORI_IMAGEN height:TXOROTXORI_IMAGEN]];
    nodoLogo.geometry.firstMaterial.diffuse.contents = @"txori.png";
    nodoLogo.geometry.firstMaterial.emission.contents = @"txori.png";
    
    // Podemos hacer un efecto de entrada de luz
    nodoLogo.geometry.firstMaterial.emission.intensity = 0;
    
    nodoLogo.position = SCNVector3Make(200, TXOROTXORI_IMAGEN/2, 1000);
    
    [nodoGrupo addChildNode:nodoLogo];
    
    
    SCNVector3 posicion = SCNVector3Make(200, 0, 1000);
    
    // Posición y rotación - diferentes ángulos
    nodoCamera.position = SCNVector3Make(200, -20, posicion.z + 150);
    nodoCamera.eulerAngles = SCNVector3Make(-M_PI_2 * 0.10, 0.0, 0.0);
    
    [escena.rootNode addChildNode:nodoGrupo];
}

// Esperar, y luego se desvanecen en la luz
- (void) efectoFadeIn {
    
    [SCNTransaction begin];
    // Retardo para comenzar
    [SCNTransaction setAnimationDuration:0.0];
    [SCNTransaction setCompletionBlock:^{
        
        [SCNTransaction begin];
        // Duracion de la animación de entrada
        [SCNTransaction setAnimationDuration:0];
        
            // Intensidad de la luz
            puntoLuzNodo.light.color = [SKColor colorWithWhite:1 alpha:1];
            nodoLogo.geometry.firstMaterial.emission.intensity = 0.70;
        
        [SCNTransaction commit];
    }];
    
    puntoLuzNodo.light.color = [SKColor colorWithWhite:0.001 alpha:1];
    
    [SCNTransaction commit];
}

@end

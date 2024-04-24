
//Function called once for every pixel on the screen
void frag(Pixel i) {
  
  ArrayList<Integer> clrs = new ArrayList<Integer>();
  for (int k = 0; k < Scene.camera.raysPerPixel; k++) { //<>//
    
    //Get origin of ray (in respect to rayDispersion)
    PVector origin = Scene.camera.position.copy();
    origin.add(new PVector(0, cos(random(-PI, PI) * Scene.camera.rayDispersion), sin(random(-PI, PI) * Scene.camera.rayDispersion)));
    
    //Calculate vector from camera position to pixel on screen
    PVector pixelPosition = PVector.add(Scene.camera.planePos, new PVector(0, float(i.x) / width * Scene.camera.planeSize.x, float(i.y) / height * Scene.camera.planeSize.y));
    PVector direction = PVector.sub(pixelPosition, origin).normalize();
    
    //Start calculating ray color from bounce 0
    clrs.add(calculateRayColor(origin, direction, 0, null));
  }
    
  //Set pixel to rayColor
  set(i.x, i.y, Scene.camera.blendColors(clrs));
}

//Recursive function that calculates color of a ray
color calculateRayColor(PVector origin, PVector direction, int bounces, GameObject originObject) {
  
  Collision collision = new Collision(origin, direction, allObjectsInScene, originObject);

  
  if (collision.didCollide)
    return computeRayCollision(collision, bounces, originObject, direction);
  
  //Ray didn't collide with anything
  if (bounces == 0)
    return lerpColor(Scene.horizonColor, Scene.sunColor, PVector.dot(Scene.sunDirection, direction));              
  
  float lerp = PVector.dot(Scene.sunDirection, PVector.lerp(direction, Scene.sunDirection, Scene.sunBrightness).normalize());   
  return lerpColor(Scene.camera.blendTwoColors(color(0), Scene.horizonColor), originObject.material.clr, lerp);
    
}

color computeRayCollision(Collision collision, int bounces, GameObject originObject, PVector direction) {
    
  //Handle Emitter materials
  if (collision.gameObject.material.isEmitter) 
    return collisionWithEmitter(collision, bounces, originObject, direction);
    
  //If on last bounce, get color in relation to sun position, without regarding other objects
  if (bounces >= Scene.camera.maxRayBounces) 
    return lerpColor(color(0), collision.gameObject.material.clr, PVector.dot(collision.normalVector, Scene.sunDirection));
  
  
  //Compute rays in accordance with gameObject material
  PVector[] newRays = collision.gameObject.material.getNewRays(direction, collision.normalVector);
  ArrayList<Integer> allRayColors = new ArrayList<Integer>();

  for (PVector bouncedRay : newRays)                
    allRayColors.add(calculateRayColor(collision.position, bouncedRay, bounces + 1, collision.gameObject));
  
  
  if (Scene.hardShadows != 0 && PVector.dot(Scene.sunDirection, collision.normalVector) > 0 && bounces == 0) {
    Collision sunCollision = new Collision(collision.position, Scene.sunDirection, allObjectsInScene, originObject);
    
    if (sunCollision.didCollide && sunCollision.gameObject != collision.gameObject) {
      for (int h = 0; h < Scene.hardShadows * allRayColors.size(); h++)
        allRayColors.add(color(0));
    }
    
  }
  
  return Scene.camera.blendColors(allRayColors);
}

//Ray collides with an object with an emitter material
color collisionWithEmitter(Collision collision, int bounces, GameObject originObject, PVector direction) {
  if (bounces == 0)
    return collision.gameObject.material.clr;
      
  float lerpQuantity = PVector.dot(collision.normalVector, direction);
  return lerpColor(originObject.material.clr, collision.gameObject.material.clr, lerpQuantity);

}

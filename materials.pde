public class Material {
  public color clr; //Colour of the material
  public float roughness; //Roughness of the material
  
  public boolean isEmitter = false; //Is the material a light source?
  public boolean isTransparent = false;
  
  public PVector[] getNewRays(PVector direction, PVector normalVector) {
    return null;
  }
  
  
  
  protected PVector SphericalCoordinate(float x, float y) {
    return new PVector(cos(x)*cos(y), sin(x)*cos(y), sin(y)); 
  }
  
  protected PVector getReflectiveRay (PVector direction, PVector normalVector) {
    return PVector.sub(direction, PVector.mult(normalVector, 2 * PVector.dot(direction, normalVector)));
  }

}

public class DiffuseMaterial extends Material {
  
  DiffuseMaterial(color c, float r) {
    clr = c;
    roughness = r;
  }
  
  @Override
  public PVector[] getNewRays(PVector direction, PVector normalVector) {
    
    //Set up from bounce
    PVector reflectiveDirection = getReflectiveRay(direction, normalVector);
             
    float diffuseRayNumbers = ceil(lerp(2, Scene.camera.raysPerDiffuse, roughness));
        
    PVector[] diffuseVectors = new PVector[int(diffuseRayNumbers)];
    int index = 0;
    
    //Get rays by placing 'diffuseRayNumber' of equidistant points on a circle
    //Algorithm uses spiral and was created by Jonathan Kogan
    //https://scholar.rose-hulman.edu/cgi/viewcontent.cgi?article=1387&context=rhumj
    for (float s = -1; s <= 1; s += 2/(diffuseRayNumbers-1)) {
      float x = 0.1 + 1.2*diffuseRayNumbers;
      PVector roughnessDirection = SphericalCoordinate(s*x, (PI/2)*signum(s)*(1-sqrt(1-abs(s)))).normalize();
      
      if (PVector.dot(roughnessDirection, normalVector) < 0) 
        roughnessDirection.mult(-1);
      
      diffuseVectors[index] = PVector.lerp(reflectiveDirection, roughnessDirection, roughness);
      index++;
    }
    
    return diffuseVectors;
  }
}

public class ReflectiveMaterial extends Material {
  
  ReflectiveMaterial(color c) {
    clr = c;
    roughness = 0;
  }
  
  @Override
  public PVector[] getNewRays(PVector direction, PVector normalVector) {
    return new PVector[] {getReflectiveRay(direction, normalVector)};
  }
}

public class EmitterMaterial extends Material {
  
  EmitterMaterial (color c) {
    clr = c; roughness = 0; isEmitter = true;  
  }
  
}

public class TransparentMaterial extends Material {
  
  public float refractionIndex;
  public float reflectiveIndex;
  
  private float refractionIndexAir = 1.0;
  
  TransparentMaterial (color c, float refraction, float reflective){
    clr = c;
    roughness = 0;
    refractionIndex = refraction;
    reflectiveIndex = reflective;
    isTransparent = true;
  }
  
  @Override
  public PVector[] getNewRays(PVector direction, PVector normalVector) {
    int nbRefractionRays = (reflectiveIndex == 1) ? 0 : max(1, int(floor((1/(-reflectiveIndex+1))-1)));
    int nbReflectionRays = (reflectiveIndex == 0) ? 0 : max(1, int(floor(1/reflectiveIndex-1)));
    
    PVector[] bouncedRays = new PVector[nbRefractionRays + nbReflectionRays];
    //Refraction
    
    for (int i_refr = 0; i_refr < nbRefractionRays; i_refr++) {
      float inAngle = acos(PVector.dot(PVector.mult(direction, -1), normalVector));
      float outAngle = asin((refractionIndexAir*sin(inAngle))/refractionIndex);
      
      float angleRatio = outAngle / inAngle;
      bouncedRays[i_refr] = PVector.lerp(PVector.mult(normalVector, -1), direction, angleRatio).normalize();
    }

    //Reflection
    for (int i_refl = 0; i_refl < nbReflectionRays; i_refl++)
      bouncedRays[i_refl + nbRefractionRays] = getReflectiveRay(direction, normalVector);
    
    return bouncedRays;
  }
  
}

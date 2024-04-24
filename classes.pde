ArrayList<GameObject> allObjectsInScene = new ArrayList<GameObject>();

public void createGameObject(GameObject gameObject) {
  allObjectsInScene.add(gameObject);
}

public class Pixel {
  public int x, y; 
  Pixel(int i, int j) {
    x = i; 
    y = j;
  }
}


public static class Scene {
  public static Camera camera;
  
  public static color sunColor;
  public static color horizonColor;
  public static PVector sunDirection = new PVector(-10, 0, -10).normalize();
  public static float sunBrightness = 0.33;
  public static float hardShadows = 0.1;
  
}

public class Camera {
  public PVector position, direction; //Position and direction of camera in 3D space
  public float fov; //Field of fiew of camera
  
  public float focalPlaneDist = 3.0; //Distance between camera and the focalplane
    
  public int raysPerPixel = 1;
  public float rayDispersion = 0;
  
  public int raysPerDiffuse = 50;
  public int maxRayBounces = 2;  
  
  public PVector planeSize, planePos; //Size and position of the plane, calculated by the focalPlaneDistance and FOV

  
  Camera(PVector p, PVector r, float f) {
    position = p; 
    direction = r.normalize(); 
    fov = f;
    
    //Setup planeSize
    float planeSizeX = 2 * focalPlaneDist * atan(fov/2);
    planeSize = new PVector(planeSizeX, (planeSizeX / width) * height);
    planePos = PVector.sub(PVector.add(position, PVector.mult(direction, focalPlaneDist)), new PVector(0, planeSize.x / 2, planeSize.y / 2)); //pos + r*focalPlaneDist - (width/2, height/2)

  }
  
  //Linearly blend the red, green and blue channel of the colours
  public color blendColors(ArrayList<Integer> colors) {
    
    if (colors.size() == 0)
      return color(0);
    

    color startColor = colors.get(0);
    float[] rgb = new float[] {red(startColor), green(startColor), blue(startColor)};
    
    for (int i = 1; i < colors.size(); i++) {
      color currentColor = colors.get(i);
      rgb[0] += red(currentColor);
      rgb[1] += green(currentColor);
      rgb[2] += blue(currentColor);
    }
    
    int arraySize = colors.size();
    return color(rgb[0] / arraySize, rgb[1] / arraySize, rgb[2] / arraySize);
  }
  
  public color blendTwoColors (color color1, color color2) {
    ArrayList<Integer> colors = new ArrayList<Integer>();
    colors.add(color1);
    colors.add(color2);
    
    return blendColors(colors);
  }
}

public class Collision {
  public GameObject gameObject = null;
  public Shape shape = null;
  public PVector position = new PVector();
  public PVector normalVector = new PVector();
  public float distance = -1;
  
  public boolean didCollide = false;
  
  Collision(PVector origin, PVector direction, ArrayList<GameObject> originalCollisionObjects, GameObject originObject) {
        
    ArrayList<GameObject> collisionObjects = new ArrayList<GameObject>(originalCollisionObjects);
    
    //Make collision with originObject impossible
    if (collisionObjects.contains(originObject) && originObject != null)
      collisionObjects.remove(originObject);
    
    //Find closest object in collison ray
    for (GameObject obj : collisionObjects) {
      
      for (Shape currentShape : obj.shapes) {
        PVector currentCollisionPosition = currentShape.checkCollision(origin, direction, obj);
        if (currentCollisionPosition == null) 
          continue; 
         
        float currentDistance = PVector.dist(currentCollisionPosition, origin);
        if (!(distance == -1 || currentDistance < distance))
          continue;
          
        PVector temporaryNormal = currentShape.getNormalVector(currentCollisionPosition, obj);
        float dotProduct = PVector.dot(temporaryNormal, direction);
        if (currentShape.isDoubleFaced && dotProduct > 0)
          temporaryNormal.mult(-1);
            
        if (!(currentShape.isDoubleFaced || dotProduct <= 0))
          continue;
        
        position = currentCollisionPosition;
        distance = currentDistance;
        shape = currentShape;
        gameObject = obj;
        normalVector = temporaryNormal;
              
        didCollide = true;       
        
      }
          
    }
  }
}


float signum(float f) {
  if (f >= 0) return 1;
  else return -1;
}

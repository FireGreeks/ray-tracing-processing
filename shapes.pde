
public class Shape {
  
  public PVector relativePosition; //Position of shape in 3D Space  
  public boolean isDoubleFaced = false;
  public boolean flipNormal = false;
  
  public PVector checkCollision(PVector origin, PVector dir, GameObject parent) {
    return null;  
  }
  
  public PVector getNormalVector(PVector atPosition, GameObject parent) {
    return null; 
  }
  
}

public class Sphere extends Shape {
  private float r; //Radius of sphere
    
  Sphere(PVector p, float radius) {
    relativePosition = p; r = radius;
  }
  
  @Override
  public PVector checkCollision(PVector origin, PVector dir, GameObject parent) {
    
    PVector absolutePosition = PVector.add(relativePosition, parent.position);
    
    PVector L = PVector.sub(absolutePosition, origin);
    float tca = PVector.dot(L, dir);
    if (tca < 0) return null;
    float d2 = PVector.dot(L, L) - tca * tca;
    if (d2 > r) return null;
    float thc = sqrt(r - d2);
    
    PVector point1 = PVector.add(origin, PVector.mult(dir, tca - thc));
    PVector point2 = PVector.add(origin, PVector.mult(dir, tca + thc));
    if (PVector.dist(origin, point1) <= PVector.dist(origin, point2))
      return point1;
    else
      return point2;
  }
  
  @Override
  public PVector getNormalVector(PVector atPosition, GameObject parent) {
    return PVector.sub(atPosition, PVector.add(relativePosition, parent.position)).normalize().mult(flipNormal ? -1 : 1);
  }
}

public class Triangle extends Shape {
  public PVector[] points;
    
  Triangle (PVector pos, PVector[] ps, boolean isD, boolean flip) {
    relativePosition = pos; points = ps; isDoubleFaced = isD; flipNormal = flip;
  }
  
  @Override
  public PVector checkCollision(PVector origin, PVector direction, GameObject parent) {
    float EPS = 0.001;
    PVector edge1, edge2, h, s, q;
    float a,f,u,v;
    
    PVector[] absolutePoints = getAbsolutePoints(parent);
    
    edge1 = PVector.sub(absolutePoints[1], absolutePoints[0]);
    edge2 = PVector.sub(absolutePoints[2], absolutePoints[0]);
    
    h = new PVector();
    q = new PVector();
   
    h = PVector.cross(direction, edge2, h);
    a = PVector.dot(edge1, h);
    
    if (a > -EPS && a < EPS)
        return null;    // This ray is parallel to this triangle.
    f = 1.0/a;
    s = PVector.sub(origin, absolutePoints[0]);
    u = f * PVector.dot(s, h);
    if (u < 0.0 || u > 1.0)
        return null;
    q = PVector.cross(s, edge1, q);
    v = f * PVector.dot(direction, q);
    if (v < 0.0 || u + v > 1.0)
        return null;
    // At this stage we can compute t to find out where the intersection point is on the line.
    float t = f * PVector.dot(edge2, q);
    if (t > EPS) // ray intersection
    {
        return PVector.add(origin, PVector.mult(direction, t));
    }
    else // This means that there is a line intersection but not a ray intersection.
        return null;
        
  }
  
  @Override
  public PVector getNormalVector(PVector atPosition, GameObject parent) {
    PVector[] absolutePoints = getAbsolutePoints(parent);
    
    PVector edge1 = PVector.sub(absolutePoints[1], absolutePoints[0]);
    PVector edge2 = PVector.sub(absolutePoints[2], absolutePoints[0]);
    
    PVector normal = new PVector();
    normal = PVector.cross(edge1, edge2, normal);
    
    return normal.normalize().mult(flipNormal ? -1 : 1);
  }
  
  private PVector[] getAbsolutePoints(GameObject parent) {
    PVector absolutePosition = PVector.add(relativePosition, parent.position);
    PVector absPoint0 = PVector.add(points[0], absolutePosition);
    PVector absPoint1 = PVector.add(points[1], absolutePosition);
    PVector absPoint2 = PVector.add(points[2], absolutePosition);
    
    return new PVector[] {absPoint0, absPoint1, absPoint2};
  }
}

 

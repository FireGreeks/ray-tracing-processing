
public class GameObject {
  
  public PVector position;
  public Shape[] shapes;
  public Material material;
 
}

public class SphereObject extends GameObject {
  
  public float radius;
  
  SphereObject(PVector p, float r, Material m) {
    position = p; radius = r; material = m;
    shapes = new Shape[] {new Sphere(new PVector(), r)};
  }
  
}

public class TriangleObject extends GameObject {
  
  public PVector[] points;
  
  TriangleObject (PVector pos, PVector[] ps, Material mat) {
    position = pos; points = ps; material = mat;
    shapes = new Shape[] {new Triangle(new PVector(), ps, true, false)};
  }
  
}

public class CustomGameObject extends GameObject {
  
  CustomGameObject(PVector pos, Shape[] s, Material mat) {
    position = pos;
    material = mat;
    shapes = s;
  }
  
}


public class Cuboid extends GameObject {
  
  public float[] dimensions;
  
  Cuboid(PVector pos, float[] dim, Material mat) {
    position = pos;
    dimensions = dim;
    material = mat;
    
    float w = dimensions[0]/2;
    float h = dimensions[1]/2;
    float l = dimensions[2]/2;
    
    PVector[] edges = {
      new PVector(-l,-w,-h), new PVector(-l,-w,h), new PVector(-l,w,h), new PVector(-l,w,-h),
      new PVector(l,-w,-h), new PVector(l,-w,h), new PVector(l,w,h), new PVector(l,w,-h)
    };
    
    shapes = new Shape[] {
      new Triangle(new PVector(), new PVector[] {edges[0], edges[1], edges[2]}, false, false),
      new Triangle(new PVector(), new PVector[] {edges[0], edges[3], edges[2]}, false, true),
      
      new Triangle(new PVector(), new PVector[] {edges[4], edges[5], edges[6]}, false, false),
      new Triangle(new PVector(), new PVector[] {edges[4], edges[7], edges[6]}, false, true),
      
      new Triangle(new PVector(), new PVector[] {edges[0], edges[4], edges[5]}, false, false),
      new Triangle(new PVector(), new PVector[] {edges[0], edges[1], edges[5]}, false, true),
      
      new Triangle(new PVector(), new PVector[] {edges[3], edges[7], edges[6]}, false, true),
      new Triangle(new PVector(), new PVector[] {edges[3], edges[2], edges[6]}, false, false),
      
      new Triangle(new PVector(), new PVector[] {edges[0], edges[3], edges[7]}, false, false),
      new Triangle(new PVector(), new PVector[] {edges[0], edges[4], edges[7]}, false, true),
      
      new Triangle(new PVector(), new PVector[] {edges[1], edges[2], edges[6]}, false, true),
      new Triangle(new PVector(), new PVector[] {edges[1], edges[5], edges[6]}, false, false)
    };
  }
}

public class Plane extends GameObject {
  
  float[] dimensions;
  
  Plane(PVector pos, float[] dim, Material mat) {
      position = pos; dimensions = dim; material = mat;
      
      float w = dimensions[0]/2;
      float h = dimensions[1]/2;
      
      PVector[] edges = new PVector[] {
        new PVector(w, -h, 0), new PVector(w, h, 0),
        new PVector(-w, -h, 0), new PVector(-w, h, 0)
      };
      
      shapes = new Shape[] {
        new Triangle(new PVector(), new PVector[] {edges[0], edges[1], edges[2]}, true, false),
        new Triangle(new PVector(), new PVector[] {edges[1], edges[3], edges[2]}, true, false)
      };
  }
}
